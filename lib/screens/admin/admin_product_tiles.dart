import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../widgets/product_image.dart';

class AdminProductTile extends StatefulWidget {
  final Product product;
  final VoidCallback onEdit;
  final ValueChanged<bool> onAvailabilityChanged;

  const AdminProductTile({
    required this.product,
    required this.onEdit,
    required this.onAvailabilityChanged,
  });

  @override
  State<AdminProductTile> createState() => _AdminProductTileState();
}

class _AdminProductTileState extends State<AdminProductTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: .98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _controller.forward(),
    onTapUp: (_) => _controller.reverse(),
    onTapCancel: _controller.reverse,
    child: ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .035),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(23),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => ProductImage(
                        imageUrl: widget.product.imageUrl,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: widget.product.isAvailable
                              ? AppColors.success
                              : AppColors.danger,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.product.isAvailable ? 'AVAILABLE' : 'OUT',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .4,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .92),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          widget.product.category == 'fish'
                              ? 'FISH'
                              : 'CHICKEN',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .6,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 7,
                      top: 7,
                      child: Container(
                        width: 38,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .94),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch.adaptive(
                            value: widget.product.isAvailable,
                            activeThumbColor: AppColors.success,
                            onChanged: widget.onAvailabilityChanged,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 3, 6, 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading3.copyWith(
                              fontSize: 12,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${widget.product.pricePerKg.toStringAsFixed(0)} / kg',
                            maxLines: 1,
                            style: AppTextStyles.price.copyWith(
                              fontSize: 13,
                              height: 1.05,
                              letterSpacing: -.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onEdit,
                      tooltip: 'Edit product',
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints.tightFor(
                        width: 28,
                        height: 28,
                      ),
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceSoft,
                        foregroundColor: AppColors.primary,
                      ),
                      icon: const Icon(Icons.edit_rounded, size: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

enum ManagementTileMode { price, stock }

class AdminManagementTile extends StatelessWidget {
  final Product product;
  final ManagementTileMode mode;
  final VoidCallback onEdit;
  final ValueChanged<bool> onAvailabilityChanged;

  const AdminManagementTile({
    required this.product,
    required this.mode,
    required this.onEdit,
    required this.onAvailabilityChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .035),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Expanded(
          flex: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => ProductImage(
                  imageUrl: product.imageUrl,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: AdminTileBadge(
                  text: product.category == 'fish' ? 'FISH' : 'CHICKEN',
                  color: Colors.white.withValues(alpha: .92),
                  textColor: AppColors.textSecondary,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: mode == ManagementTileMode.stock
                    ? Container(
                        width: 38,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .94),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: FittedBox(
                          child: Switch.adaptive(
                            value: product.isAvailable,
                            activeThumbColor: AppColors.success,
                            onChanged: onAvailabilityChanged,
                          ),
                        ),
                      )
                    : AdminTileBadge(
                        text: 'EDIT',
                        color: AppColors.primary,
                        textColor: Colors.white,
                      ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: AdminTileBadge(
                  text: product.isAvailable ? 'AVAILABLE' : 'OUT OF STOCK',
                  color: product.isAvailable ? AppColors.success : AppColors.danger,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 7, 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading3.copyWith(fontSize: 12, height: 1.05),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        mode == ManagementTileMode.price
                            ? '₹${product.pricePerKg.toStringAsFixed(0)} / kg'
                            : product.isAvailable
                            ? 'Available today'
                            : 'Needs restock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (mode == ManagementTileMode.price
                                ? AppTextStyles.price
                                : AppTextStyles.caption)
                            .copyWith(
                              fontSize: mode == ManagementTileMode.price ? 13 : 11,
                              height: 1.05,
                              color: mode == ManagementTileMode.stock
                                  ? product.isAvailable
                                      ? AppColors.success
                                      : AppColors.danger
                                  : AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
                if (mode == ManagementTileMode.price)
                  IconButton(
                    onPressed: onEdit,
                    tooltip: 'Edit price',
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primarySoft,
                      foregroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 14),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class AdminTileBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const AdminTileBadge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 7.5,
        fontWeight: FontWeight.w900,
        letterSpacing: .45,
      ),
    ),
  );
}

class AdminPriceRow extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;

  const AdminPriceRow({required this.product, required this.onEdit});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .025),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ProductImage(
            imageUrl: product.imageUrl,
            width: 58,
            height: 58,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: AppTextStyles.heading3.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 3),
              Text(
                product.category == 'fish' ? 'FISH' : 'CHICKEN',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9,
                  letterSpacing: .7,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Text(
          '₹${product.pricePerKg.toStringAsFixed(0)} /kg',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onEdit,
          tooltip: 'Edit price',
          icon: const Icon(Icons.edit_outlined, size: 18),
        ),
      ],
    ),
  );
}

class AdminEmptyProducts extends StatelessWidget {
  const AdminEmptyProducts();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 50),
    child: Column(
      children: [
        Icon(Icons.search_off_rounded, size: 42, color: AppColors.textMuted),
        const SizedBox(height: 12),
        Text('No products found', style: AppTextStyles.heading3),
        const SizedBox(height: 5),
        Text('Try another search or category.', style: AppTextStyles.body),
      ],
    ),
  );
}
