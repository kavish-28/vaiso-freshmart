// The ONE product card used by the customer catalogue (fish and chicken).
// Category look is controlled with [accentColor] and [fallbackIcon].

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import 'product_image.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final Color accentColor;
  final IconData fallbackIcon;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.accentColor = AppColors.primary,
    this.fallbackIcon = Icons.set_meal_rounded,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  void _handleTap() {
    setState(() => _pressed = true);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _pressed = false);
      }
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: _buildImageArea(product)),
              Expanded(flex: 4, child: _buildDetails(product)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea(Product product) {
    return Stack(
      children: [
        Positioned.fill(
          child: ProductImage(
            imageUrl: product.imageUrl,
            fallbackIcon: widget.fallbackIcon,
            fallbackColor: widget.accentColor,
            fallbackIconSize: 38,
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: product.isAvailable
                  ? AppColors.success
                  : AppColors.danger,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.isAvailable ? 'AVAILABLE' : 'OUT',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.90),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_outward_rounded,
              size: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading3.copyWith(fontSize: 14),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${product.pricePerKg.toStringAsFixed(0)}',
                style: AppTextStyles.price.copyWith(
                  fontSize: 19,
                  color: widget.accentColor,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '/ kg',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
