import 'package:flutter/material.dart';

class CHIButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const CHIButton({
    super.key,
    this.label,
    this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.black,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: Text(label ?? ""),
      icon: icon ?? const SizedBox.shrink(),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.8),
        disabledForegroundColor: textColor.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
