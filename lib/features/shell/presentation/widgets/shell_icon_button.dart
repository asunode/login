import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neumorphic_container.dart';

class ShellIconButton extends StatefulWidget {
  const ShellIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  State<ShellIconButton> createState() => _ShellIconButtonState();
}

class _ShellIconButtonState extends State<ShellIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;

    final button = GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: AppConstants.durationButton,
        child: NeumorphicContainer(
          style: _pressed ? NeumorphicStyle.concave : NeumorphicStyle.convex,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          padding: const EdgeInsets.all(8),
          child: Icon(
            widget.icon,
            size: AppConstants.iconCard,
            color: textColor,
          ),
        ),
      ),
    );

    return widget.tooltip == null
        ? button
        : Tooltip(
            message: widget.tooltip!,
            child: button,
          );
  }
}


