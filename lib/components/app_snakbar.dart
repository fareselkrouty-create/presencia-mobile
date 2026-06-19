import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  static void show({
    required String message,
    SnackType type = SnackType.info,
    String? title,
  }) {
    final Map<SnackType, (Color, Color, IconData)> config = {
      SnackType.success: (const Color(0xFF2E7D32), const Color(0xFFE6F4EA), Icons.check_circle_outline),
      SnackType.error:   (const Color(0xFFC62828), const Color(0xFFFFEBEE), Icons.error_outline),
      SnackType.warning: (const Color(0xFFF57F17), const Color(0xFFFFF8E1), Icons.warning_amber_outlined),
      SnackType.info:    (const Color(0xFF1565C0), const Color(0xFFE3F2FD), Icons.info_outline),
    };

    final (fgColor, bgColor, icon) = config[type]!;

    Get.snackbar(
      title ?? _defaultTitle(type),
      message,
      backgroundColor: bgColor,
      colorText: fgColor,
      icon: Icon(icon, color: fgColor),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static String _defaultTitle(SnackType type) => switch (type) {
    SnackType.success => 'Succès',
    SnackType.error   => 'Erreur',
    SnackType.warning => 'Attention',
    SnackType.info    => 'Info',
  };
}