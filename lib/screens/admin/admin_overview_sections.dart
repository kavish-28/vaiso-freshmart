import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product.dart';
import 'admin_cards.dart';
import 'admin_product_tiles.dart';

/// 2-column grid of gradient stat cards on the dashboard page.
class AdminSummaryGrid extends StatelessWidget {
  final int total;
  final int available;
  final int unavailable;
  final double width;

  const AdminSummaryGrid({
    super.key,
    required this.total,
    required this.available,
    required this.unavailable,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        'TOTAL CUTS',
        '$total',
        Icons.inventory_2_outlined,
        const Color(0xFF1647B8),
      ),
      (
        'AVAILABLE',
        '$available',
        Icons.check_circle_outline_rounded,
        const Color(0xFF1261FF),
      ),
      (
        'NEEDS RESTOCK',
        '$unavailable',
        Icons.remove_shopping_cart_outlined,
        const Color(0xFF2377D5),
      ),
      ('CATEGORIES', '02', Icons.grid_view_rounded, const Color(0xFF334FC4)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: width >= 680
            ? 3.1
            : width <= 340
            ? 1.25
            : 1.55,
      ),
      itemBuilder: (_, index) => AdminStatCard(
        label: stats[index].$1,
        value: stats[index].$2,
        icon: stats[index].$3,
        color: stats[index].$4,
      ),
    );
  }
}

/// "Quick actions" 2x2 grid on the dashboard page.
class AdminQuickActions extends StatelessWidget {
  final VoidCallback onAddFish;
  final VoidCallback onAddChicken;
  final VoidCallback onOpenPrices;
  final VoidCallback onOpenStock;

  const AdminQuickActions({
    super.key,
    required this.onAddFish,
    required this.onAddChicken,
    required this.onOpenPrices,
    required this.onOpenStock,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Quick actions', style: AppTextStyles.heading2),
      const SizedBox(height: 13),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 11,
        crossAxisSpacing: 11,
        childAspectRatio: 2.35,
        children: [
          AdminQuickActionCard(
            label: 'Add fish',
            icon: Icons.set_meal_rounded,
            color: AppColors.primary,
            onTap: onAddFish,
          ),
          AdminQuickActionCard(
            label: 'Add chicken',
            icon: Icons.restaurant_rounded,
            color: AppColors.chicken,
            onTap: onAddChicken,
          ),
          AdminQuickActionCard(
            label: 'Daily prices',
            icon: Icons.price_change_rounded,
            color: AppColors.aqua,
            onTap: onOpenPrices,
          ),
          AdminQuickActionCard(
            label: 'Manage stock',
            icon: Icons.fact_check_rounded,
            color: AppColors.success,
            onTap: onOpenStock,
          ),
        ],
      ),
    ],
  );
}

/// "Today's prices" list (first few products) on the dashboard page.
class AdminPriceHighlights extends StatelessWidget {
  final List<Product> products;
  final VoidCallback onSeeAll;
  final ValueChanged<Product> onEdit;

  const AdminPriceHighlights({
    super.key,
    required this.products,
    required this.onSeeAll,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Expanded(
            child: Text('Today’s prices', style: AppTextStyles.heading2),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ...products.map(
        (product) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: AdminPriceRow(
            product: product,
            onEdit: () => onEdit(product),
          ),
        ),
      ),
    ],
  );
}

/// Available / Out-of-stock counters at the top of the Stock page.
class AdminStockSummary extends StatelessWidget {
  final int available;
  final int unavailable;

  const AdminStockSummary({
    super.key,
    required this.available,
    required this.unavailable,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: AdminStockCountCard(
          label: 'Available',
          value: available.toString(),
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
        ),
      ),
      const SizedBox(width: 11),
      Expanded(
        child: AdminStockCountCard(
          label: 'Out of stock',
          value: unavailable.toString(),
          icon: Icons.remove_shopping_cart_outlined,
          color: AppColors.danger,
        ),
      ),
    ],
  );
}
