import 'package:flutter/material.dart';

/// Simple wireframe mode - just replace Text and Image with grey boxes
/// without changing the structure

/// Global flag to enable/disable wireframe mode
const bool kWireframeMode = true;

/// Replace Text with grey box
class WText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const WText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    if (!kWireframeMode) {
      return Text(
        data,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
      );
    }

    // Calculate width based on text length
    final double boxWidth = (data.length * 8.0).clamp(40.0, 300.0);
    final double boxHeight = (style?.fontSize ?? 14.0) * 0.8;

    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Replace Image with grey box
class WImage extends StatelessWidget {
  final ImageProvider? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const WImage.network(
    String src, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  }) : image = null;

  const WImage.asset(
    String name, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  }) : image = null;

  const WImage({
    super.key,
    this.image,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (!kWireframeMode && image != null) {
      return Image(
        image: image!,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE0E0E0),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

/// Replace CircleAvatar with grey circle
class WAvatar extends StatelessWidget {
  final ImageProvider? backgroundImage;
  final double radius;
  final Widget? child;
  final Color? backgroundColor;

  const WAvatar({
    super.key,
    this.backgroundImage,
    this.radius = 20,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!kWireframeMode && backgroundImage != null) {
      return CircleAvatar(
        backgroundImage: backgroundImage,
        radius: radius,
        child: child,
        backgroundColor: backgroundColor,
      );
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
      child: child, // Tidak ada default icon, hanya grey circle
    );
  }
}

/// Replace Icon with grey box
class WIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const WIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!kWireframeMode) {
      return Icon(icon, size: size, color: color);
    }

    final double boxSize = size ?? 24.0;
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
