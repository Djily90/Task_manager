import 'package:flutter/material.dart';

/// This file contains all the constants used in the app
class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF4A67FF);
  static const Color secondaryColor = Color(0xFF6C8EFF);
  static const Color accentColor = Color(0xFF344BD0);

  // Text colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);

  // Task status colors
  static const Color taskCompleted = Color(0xFF28A745);
  static const Color taskPending = Color(0xFFFFC107);

  // UI element colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color deleteColor = Color(0xFFDC3545);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    color: AppColors.textSecondary,
  );

  static TextStyle taskCompleted = const TextStyle(
    fontSize: 16.0,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle taskPending = TextStyle(
    fontSize: 16.0,
    color: AppColors.textPrimary,
  );
}

class AppDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class AppPadding {
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
  static const double itemSpacing = 12.0;
}
