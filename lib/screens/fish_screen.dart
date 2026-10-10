import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import 'product_details_screen.dart';

class FishScreen extends StatefulWidget {
  const FishScreen({super.key});

  @override
  State<FishScreen> createState() => _FishScreenState();
}

class _FishScreenState extends State<FishScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    List<Product> products = List<Product>.from(fishList);

    if (_selectedFilter == 'Available') {
      products = products.where((p) => p.isAvailable).toList();
    }

    if (_selectedFilter == 'Unavailable') {
      products = products.where((p) => !p.isAvailable).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      products = products.where((product) {
        return product.name.toLowerCase().contains(
              _searchQuery.toLowerCase().trim(),
            );
      }).toList();
    }

    return products;
  }

  void _openDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(
          product: product,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableCount =
        fishList.where((product) => product.isAvailable).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildHeader(
                  availableCount,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildSearch(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildFilters(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                22,
                20,
                30,
              ),
              sliver: _filteredProducts.isEmpty
                  ? SliverToBoxAdapter(
                      child: _buildEmptyState(),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = _filteredProducts[index];

                          return _ProductGridCard(
                            product: product,
                            onTap: () => _openDetails(product),
                          );
                        },
                        childCount: _filteredProducts.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.73,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int availableCount) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fish',
                style: AppTextStyles.display.copyWith(
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${fishList.length} varieties • $availableCount available',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.set_meal_rounded,
            color: AppColors.primary,
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search fish...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 21,
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();

                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 19,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterChip(
            label: 'All',
            selected: _selectedFilter == 'All',
            onTap: () {
              setState(() {
                _selectedFilter = 'All';
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterChip(
            label: 'Available',
            selected: _selectedFilter == 'Available',
            icon: Icons.check_circle_outline_rounded,
            onTap: () {
              setState(() {
                _selectedFilter = 'Available';
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterChip(
            label: 'Unavailable',
            selected: _selectedFilter == 'Unavailable',
            icon: Icons.remove_circle_outline_rounded,
            onTap: () {
              setState(() {
                _selectedFilter = 'Unavailable';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: AppColors.textMuted,
              size: 28,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'No fish found',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 5),
          Text(
            'Try a different search or filter.',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// FILTER CHIP
// ═══════════════════════════════════════════════════

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.textPrimary
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? AppColors.textPrimary
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: selected
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// PRODUCT GRID CARD
// ═══════════════════════════════════════════════════

class _ProductGridCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductGridCard({
    required this.product,
    required this.onTap,
  });

  @override
  State<_ProductGridCard> createState() =>
      _ProductGridCardState();
}

class _ProductGridCardState
    extends State<_ProductGridCard> {

  bool _pressed = false;

  void _handleTap() {
    setState(() {
      _pressed = true;
    });

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (mounted) {
          setState(() {
            _pressed = false;
          });
        }
      },
    );

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
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: AppColors.surfaceSoft,
                            child: const Icon(
                              Icons.set_meal_rounded,
                              color: AppColors.primary,
                              size: 38,
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: product.isAvailable
                              ? AppColors.success
                              : AppColors.danger,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.isAvailable
                              ? 'AVAILABLE'
                              : 'OUT',
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
                          color: Colors.white.withOpacity(0.90),
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
                ),
              ),

              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    13,
                    11,
                    13,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 14,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${product.pricePerKg.toStringAsFixed(0)}',
                            style: AppTextStyles.price.copyWith(
                              fontSize: 19,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2),
                            child: Text(
                              '/ kg',
                              style:
                                  AppTextStyles.caption.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
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
}