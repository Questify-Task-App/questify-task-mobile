import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:questify_task_mobile/main.dart';

class UpdateService {
  static const String _repoOwner = 'Questify-Task-App';
  static const String _repoName = 'questify-task-mobile';

  // Check if app is running in production mode
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  // Get context from global navigator key
  static BuildContext? get _context => navigatorKey.currentContext;

  static Future<void> checkForUpdates([BuildContext? context]) async {
    final ctx = context ?? _context;
    if (ctx == null) return;

    try {
      // Get current app information
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Fetch latest version from GitHub
      final response = await http.get(
        Uri.parse(
          'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest',
        ),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String latestVersion = data['tag_name'].replaceFirst('v', '');

        // Compare versions
        if (_isNewerVersion(currentVersion, latestVersion)) {
          final String releaseNotes = data['body'] ?? '';

          // Find APK for download
          final List<dynamic> assets = data['assets'] ?? [];
          String? downloadUrl;
          String? fileName;

          for (var asset in assets) {
            if (asset['name'].toString().contains('arm64-v8a-release.apk')) {
              downloadUrl = asset['browser_download_url'];
              fileName = asset['name'];
              break;
            }
          }

          if (downloadUrl != null && fileName != null) {
            _showUpdateDialog(
              latestVersion,
              releaseNotes,
              downloadUrl,
              fileName,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  static bool _isNewerVersion(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      final latestPart = i < latestParts.length ? latestParts[i] : 0;

      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }

    return false;
  }

  static void _showUpdateDialog(
    String version,
    String notes,
    String downloadUrl,
    String fileName,
  ) {
    final context = _context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New version $version is available!'),
              const SizedBox(height: 16),
              if (notes.isNotEmpty) ...[
                const Text(
                  'What\'s new:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(notes, maxLines: 10, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _downloadAndInstallUpdate(
                  downloadUrl,
                  fileName,
                  version,
                );
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      // Android 11+ (API 30+) - Use manage external storage or scoped storage
      if (androidInfo.version.sdkInt >= 30) {
        final manageStorageStatus = await Permission.manageExternalStorage.request();
        if (manageStorageStatus.isGranted) {
          return true;
        }
        return true; // Fallback to app's external directory
      } 
      // Android 10 (API 29) - Scoped storage but can still use legacy
      else if (androidInfo.version.sdkInt >= 29) {
        final storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
      // Android 9 and below - Use legacy storage permission
      else {
        final storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
    }
    
    return true; // iOS or other platforms
  }

  static Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      // For Android 11+, prefer app's external directory to avoid permission issues
      if (androidInfo.version.sdkInt >= 30) {
        // Try to use public Downloads directory if we have MANAGE_EXTERNAL_STORAGE
        if (await Permission.manageExternalStorage.isGranted) {
          final publicDownloads = Directory('/storage/emulated/0/Download');
          if (await publicDownloads.exists()) {
            return publicDownloads;
          }
        }
        
        // Fallback to app's external directory (doesn't need special permission)
        return await getExternalStorageDirectory();
      } else {
        // For older Android versions, use public Downloads directory
        final publicDownloads = Directory('/storage/emulated/0/Download');
        if (await publicDownloads.exists()) {
          return publicDownloads;
        }
        return await getExternalStorageDirectory();
      }
    }
    
    return await getApplicationDocumentsDirectory();
  }

  static Future<void> _downloadAndInstallUpdate(
    String downloadUrl,
    String fileName,
    String version,
  ) async {
    try {
      // Request storage permission
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        final context = _context;
        if (context != null) {
          _showPermissionDialog();
        }
        return;
      }

      final context = _context;
      if (context == null) return;

      // Show download progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return WillPopScope(
            onWillPop: () async => false,
            child: const DownloadProgressDialog(),
          );
        },
      );

      // Get downloads directory
      final downloadsDir = await _getDownloadDirectory();
      
      if (downloadsDir == null) {
        throw Exception('Could not access downloads directory');
      }

      final file = File('${downloadsDir.path}/$fileName');

      // Download the file
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final bytes = await streamedResponse.stream.toBytes();
        await file.writeAsBytes(bytes);

        // Close download dialog and show success
        final successContext = _context;
        if (successContext != null) {
          Navigator.of(successContext).pop(); // Close progress dialog
          _showDownloadCompleteDialog(file.path, version);
        }
      } else {
        throw Exception('Failed to download: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Close download dialog and show error
      final errorContext = _context;
      if (errorContext != null) {
        try {
          Navigator.of(errorContext).pop(); // Close progress dialog
        } catch (_) {}
        _showErrorDialog('Failed to download update: $e');
      }

      debugPrint('Download error: $e');
    }
  }

  static void _showPermissionDialog() {
    final context = _context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'Storage permission is required to download the update. Please grant permission in the app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  static void _showDownloadCompleteDialog(
    String filePath,
    String version,
  ) {
    final context = _context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Download Complete'),
          content: Text(
            'Version $version has been downloaded successfully.\n\nTap "Install" to open the installer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final result = await OpenFilex.open(filePath);
                  debugPrint('Open file result: ${result.message}');
                } catch (e) {
                  debugPrint('Error opening file: $e');
                  _showErrorDialog(
                    'Could not open installer. Please install manually from Downloads folder.',
                  );
                }
              },
              child: const Text('Install'),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(String message) {
    final context = _context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to be called after MaterialApp is ready (no context needed)
  static void initializeUpdateChecker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdates();
    });
  }
}

class DownloadProgressDialog extends StatelessWidget {
  const DownloadProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Downloading update...'),
          const SizedBox(height: 8),
          Text(
            'Please wait while the new version is being downloaded.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}