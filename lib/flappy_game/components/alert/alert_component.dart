import 'package:flutter/material.dart';

class AlertComponent {
  static Future<void> showAnimationDialog({required Widget child, required BuildContext context}) async {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "",
        context: context,
        pageBuilder: (ctx, a1, a2) {
          return child;
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        useRootNavigator: false);
  }
}