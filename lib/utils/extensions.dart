import 'package:flutter/material.dart';
import '../components/status_badge.dart';
import 'constants.dart';

extension StringExt on String {
  // "bonjour monde" → "Bonjour Monde"
  String get capitalizeWords => split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  // "PRESENT" → PointageStatus.present
  PointageStatus get toPointageStatus => switch (this) {
    AppConstants.statutPresent => PointageStatus.present,
    AppConstants.statutAbsent  => PointageStatus.absent,
    AppConstants.statutRetard  => PointageStatus.retard,
    AppConstants.statutConge   => PointageStatus.enConge,
    _                          => PointageStatus.absent,
  };

  bool get isValidEmail {
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(trim());
  }
}

extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
}

extension ContextExt on BuildContext {
  ThemeData get theme       => Theme.of(this);
  ColorScheme get colors    => Theme.of(this).colorScheme;
  TextTheme get textTheme   => Theme.of(this).textTheme;
  double get screenWidth    => MediaQuery.of(this).size.width;
  double get screenHeight   => MediaQuery.of(this).size.height;
  bool get isDark           => Theme.of(this).brightness == Brightness.dark;
}