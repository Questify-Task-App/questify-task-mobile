import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpdateService {
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  static Widget wrapWithUpgrader({required Widget child}) {
    if (!isProduction) {
      return child;
    }

    return UpgradeAlert(
      upgrader: Upgrader(
        durationUntilAlertAgain: const Duration(hours: 1),
        showIgnore: false,
        showLater: false,
        canDismissDialog: false,
        dialogStyle: UpgradeDialogStyle.material,
        messages: UpgraderMessages(code: 'en_US'),
      ),
      child: child,
    );
  }
}
