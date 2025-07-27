import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateService {
  static const String _repoOwner = 'Questify-Task-App';
  static const String _repoName = 'questify-task-mobile';

  // Check if app is running in production mode
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  static Future<void> checkForUpdates(BuildContext context) async {
    // Only check for updates in production mode
    if (!isProduction) {
      debugPrint('Update check skipped: Not in production mode');
      return;
    }

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

          if (downloadUrl != null && context.mounted) {
            _showUpdateDialog(
              context,
              latestVersion,
              releaseNotes,
              downloadUrl,
              fileName!,
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
    BuildContext context,
    String version,
    String notes,
    String downloadUrl,
    String fileName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadAndInstallUpdate(
                  context,
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

  static Future<void> _downloadAndInstallUpdate(
    BuildContext context,
    String downloadUrl,
    String fileName,
    String version,
  ) async {
    // Request storage permission
    final storagePermission = await Permission.storage.request();
    if (!storagePermission.isGranted) {
      _showErrorDialog(
        context,
        'Storage permission is required to download the update.',
      );
      return;
    }

    // Show download progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DownloadProgressDialog();
      },
    );

    try {
      // Get downloads directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

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

        // Close download dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }

        // Show success dialog and open installer
        if (context.mounted) {
          _showDownloadCompleteDialog(context, file.path, version);
        }
      } else {
        throw Exception('Failed to download: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Close download dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to download update: $e');
      }

      debugPrint('Download error: $e');
    }
  }

  static void _showDownloadCompleteDialog(
    BuildContext context,
    String filePath,
    String version,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Complete'),
          content: Text(
            'Version $version has been downloaded successfully.\n\nTap "Install" to open the installer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Open the APK file for installation
                try {
                  final result = await OpenFilex.open(filePath);
                  debugPrint('Open file result: ${result.message}');
                } catch (e) {
                  debugPrint('Error opening file: $e');
                  if (context.mounted) {
                    _showErrorDialog(
                      context,
                      'Could not open installer. Please install manually from Downloads folder.',
                    );
                  }
                }
              },
              child: const Text('Install'),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Widget wrapWithUpdateChecker({required Widget child}) {
    return child;
  }

  // Method to be called after MaterialApp is ready
  static void initializeUpdateChecker(BuildContext context) {
    // Check for updates after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdates(context);
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
