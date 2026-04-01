import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

enum NeumorphicStyle { convex, concave, flat }

class NeumorphicContainer extends StatelessWidget {
  const NeumorphicContainer({
    super.key,
    this.child,
    this.style = NeumorphicStyle.convex,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
  });

  final Widget? child;
  final NeumorphicStyle style;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final radius =
        borderRadius ?? BorderRadius.circular(AppConstants.radiusCard);
    final brightness = Theme.of(context).brightness;
    final bgColor = color ??
        (brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.background);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        boxShadow: _buildShadows(style, brightness),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: _buildContent(context, style, radius),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NeumorphicStyle style,
    BorderRadius radius,
  ) {
    if (style == NeumorphicStyle.concave) {
      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _InnerShadowPainter(
                radius: radius,
                brightness: Theme.of(context).brightness,
              ),
            ),
          ),
          if (child != null)
            Padding(
              padding: padding ?? const EdgeInsets.all(AppConstants.paddingSmall),
              child: child,
            ),
        ],
      );
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }

  static List<BoxShadow> _buildShadows(
    NeumorphicStyle style,
    Brightness brightness,
  ) {
    final darkColor = brightness == Brightness.dark
        ? AppColors.shadowDarkMode.withValues(alpha: 0.85)
        : AppColors.shadowDark.withValues(alpha: 0.7);
    final lightColor = brightness == Brightness.dark
        ? AppColors.shadowLightMode.withValues(alpha: 0.75)
        : AppColors.shadowLight.withValues(alpha: 0.6);

    switch (style) {
      case NeumorphicStyle.convex:
        return [
          BoxShadow(
            color: darkColor,
            offset: const Offset(6, 6),
            blurRadius: 16,
          ),
          BoxShadow(
            color: lightColor,
            offset: const Offset(-6, -6),
            blurRadius: 16,
          ),
        ];
      case NeumorphicStyle.concave:
        return [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.45),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: lightColor.withValues(alpha: 0.45),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ];
      case NeumorphicStyle.flat:
        return [];
    }
  }
}

class _InnerShadowPainter extends CustomPainter {
  _InnerShadowPainter({
    required this.radius,
    required this.brightness,
  });

  final BorderRadius radius;
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect);

    canvas.saveLayer(rect, Paint());
    canvas.clipRRect(rrect);

    _drawInnerShadow(
      canvas,
      size,
      rrect,
      color: brightness == Brightness.dark
          ? AppColors.shadowDarkMode.withValues(alpha: 0.85)
          : AppColors.shadowDark.withValues(alpha: 0.7),
      offset: const Offset(4, 4),
      blur: 8,
    );

    _drawInnerShadow(
      canvas,
      size,
      rrect,
      color: brightness == Brightness.dark
          ? AppColors.shadowLightMode.withValues(alpha: 0.6)
          : AppColors.shadowLight.withValues(alpha: 0.6),
      offset: const Offset(-4, -4),
      blur: 8,
    );

    canvas.restore();
  }

  void _drawInnerShadow(
    Canvas canvas,
    Size size,
    RRect rrect, {
    required Color color,
    required Offset offset,
    required double blur,
  }) {
    final shadowPaint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    final outerRect = Rect.fromLTRB(
      -size.width,
      -size.height,
      size.width * 2,
      size.height * 2,
    );

    final path = Path()
      ..addRect(outerRect)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerShadowPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.brightness != brightness;
  }
}


