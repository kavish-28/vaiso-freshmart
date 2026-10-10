// One shared widget used everywhere we show a product photo.
// It automatically decides: local bundled photo (fast, offline) or
// internet placeholder (temporary, until we get the real photo).
// This means product_card.dart and product_details_screen.dart never
// need to know or care which type of image a product has.

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  bool get _isNetworkImage => imageUrl.startsWith("http");

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
      color: Colors.grey.shade100,
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
      color: Colors.grey.shade100,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey.shade400,
        size: 28,
      ),
    );
  }
}
