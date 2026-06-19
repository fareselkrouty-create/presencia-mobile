import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ButtonType { primary, secondary, danger, outline }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<ButtonType, Color> bgColors = {
      ButtonType.primary: theme.colorScheme.primary,
      ButtonType.secondary: theme.colorScheme.secondary,
      ButtonType.danger: theme.colorScheme.error,
      ButtonType.outline: Colors.transparent,
    };

    final Map<ButtonType, Color> textColors = {
      ButtonType.primary: Colors.white,
      ButtonType.secondary: Colors.white,
      ButtonType.danger: Colors.white,
      ButtonType.outline: theme.colorScheme.primary,
    };

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColors[type],
          foregroundColor: textColors[type],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: type == ButtonType.outline
                ? BorderSide(color: theme.colorScheme.primary)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
