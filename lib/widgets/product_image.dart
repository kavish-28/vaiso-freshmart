// One shared widget used everywhere we show a product photo.
// It automatically decides: local bundled photo (fast, offline) or
// internet placeholder (temporary, until we get the real photo).
//
// width / height are optional: leave them out when the parent already gives
// tight constraints (for example inside Positioned.fill) and the image will
// simply fill the space.

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final double fallbackIconSize;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_not_supported_outlined,
    this.fallbackColor = AppColors.textMuted,
    this.fallbackIconSize = 28,
  });

  bool get _isNetworkImage => imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder();
        },
        errorBuilder: (context, error, stackTrace) => _errorIcon(),
      );
    }

    // Local asset - loads instantly, works with no internet at all.
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _errorIcon(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceSoft,
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _errorIcon() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceSoft,
      child: Center(
        child: Icon(
          fallbackIcon,
          color: fallbackColor,
          size: fallbackIconSize,
        ),
      ),
    );
  }
}
