import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSvgAsset extends StatelessWidget {
  final String assetPath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;

  const AppSvgAsset(
    this.assetPath, {
    Key? key,
    this.height = 16,
    this.width = 16,
    this.color,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  AppSvgAsset copyWith({
    String? assetPath,
    double? height,
    double? width,
    Color? color,
  }) {
    return AppSvgAsset(
      assetPath ?? this.assetPath,
      height: height ?? this.height,
      width: width ?? this.width,
      color: color ?? this.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetPath,
      height: height,
      width: width,

      fit: fit,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
