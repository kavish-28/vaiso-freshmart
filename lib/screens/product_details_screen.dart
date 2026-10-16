import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';


class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  bool get _isFish => product.category.toLowerCase() == 'fish';

  Color get _accentColor {
    return _isFish
        ? AppColors.primary
        : const Color(0xFFE87922);
  }

  String get _categoryLabel {
    return _isFish ? 'Sea Fish' : 'Chicken';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildImageHeader(context),
            ),

            SliverToBoxAdapter(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // IMAGE HEADER
  // ═════════════════════════════════════════════════

  Widget _buildImageHeader(BuildContext context) {
    return Container(
      height: 335,
      margin: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        0,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ProductImage(
              imageUrl: product.imageUrl,
              width: double.infinity,
              height: 335,
              fit: BoxFit.cover,
            ),
          ),

          // Dark gradient at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 145,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.58),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            left: 14,
            top: 14,
            child: _GlassButton(
              icon: Icons.arrow_back_rounded,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // More button
          Positioned(
            right: 14,
            top: 14,
            child: _GlassButton(
              icon: Icons.more_horiz_rounded,
              onTap: () {},
            ),
          ),

          // Availability
          Positioned(
            left: 18,
            bottom: 18,
            child: _AvailabilityBadge(
              isAvailable: product.isAvailable,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // CONTENT
  // ═════════════════════════════════════════════════

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        35,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _categoryLabel.toUpperCase(),
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.circle,
                size: 4,
                color: AppColors.textMuted,
              ),

              const SizedBox(width: 8),

              Text(
                'Price information',
                style: AppTextStyles.caption,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Product name
          Text(
            product.name,
            style: AppTextStyles.display.copyWith(
              fontSize: 30,
              height: 1.05,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            _isFish
                ? 'Fresh seafood price & availability'
                : 'Fresh chicken price & availability',
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 24),

          // Price
          _buildPrice(),

          const SizedBox(height: 20),

          // Availability card
          _buildAvailabilityCard(),

          const SizedBox(height: 25),

          // Information
          _buildInformationSection(),

          const SizedBox(height: 25),

          // Notice
          _buildNotice(),

          const SizedBox(height: 22),

          // Bottom back button
          _buildBackButton(context),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // PRICE
  // ═════════════════════════════════════════════════

  Widget _buildPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₹${product.pricePerKg.toStringAsFixed(0)}',
          style: TextStyle(
            color: _accentColor,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),

        const SizedBox(width: 7),

        Padding(
          padding: const EdgeInsets.only(
            bottom: 6,
          ),
          child: Text(
            '/ kg',
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════
  // AVAILABILITY
  // ═════════════════════════════════════════════════

  Widget _buildAvailabilityCard() {
    final available = product.isAvailable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: available
            ? AppColors.successSoft
            : AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: available
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.danger.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              available
                  ? Icons.check_rounded
                  : Icons.remove_rounded,
              color: available
                  ? AppColors.success
                  : AppColors.danger,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  available
                      ? 'Available today'
                      : 'Currently unavailable',
                  style: TextStyle(
                    color: available
                        ? AppColors.successDark
                        : AppColors.danger,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  available
                      ? 'Fresh stock is currently available.'
                      : 'Please check again later for availability.',
                  style: AppTextStyles.caption.copyWith(
                    color: available
                        ? AppColors.successDark
                        : AppColors.danger,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // PRODUCT INFORMATION
  // ═════════════════════════════════════════════════

  Widget _buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRODUCT INFORMATION',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 13),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon: _isFish
                    ? Icons.set_meal_outlined
                    : Icons.restaurant_outlined,
                label: 'Category',
                value: _categoryLabel,
                iconColor: _accentColor,
              ),

              const Divider(
                height: 1,
                indent: 17,
                endIndent: 17,
                color: AppColors.border,
              ),

              _InfoRow(
                icon: Icons.scale_outlined,
                label: 'Price unit',
                value: 'Per kilogram',
                iconColor: _accentColor,
              ),

              const Divider(
                height: 1,
                indent: 17,
                endIndent: 17,
                color: AppColors.border,
              ),

              _InfoRow(
                icon: product.isAvailable
                    ? Icons.check_circle_outline_rounded
                    : Icons.remove_circle_outline_rounded,
                label: 'Availability',
                value: product.isAvailable
                    ? 'In stock'
                    : 'Out of stock',
                iconColor: product.isAvailable
                    ? AppColors.success
                    : AppColors.danger,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════
  // NOTICE
  // ═════════════════════════════════════════════════

  Widget _buildNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Prices and availability may change during '
              'the day. Please check the app for the latest '
              'information.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDark,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // BACK BUTTON
  // ═════════════════════════════════════════════════

  Widget _buildBackButton(BuildContext context)  {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          size: 19,
        ),
        label: const Text(
          'Back to prices',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// GLASS BUTTON
// ═══════════════════════════════════════════════════

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.90),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// AVAILABILITY BADGE
// ═══════════════════════════════════════════════════

class _AvailabilityBadge extends StatelessWidget {
  final bool isAvailable;

  const _AvailabilityBadge({
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success
            : AppColors.danger,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: Colors.white,
            size: 15,
          ),

          const SizedBox(width: 6),

          Text(
            isAvailable
                ? 'AVAILABLE'
                : 'OUT OF STOCK',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// INFO ROW
// ═══════════════════════════════════════════════════

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 19,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}