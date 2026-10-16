// One screen for BOTH the Fish tab and the Chicken tab.
// The only differences between the two are in [CatalogueCategory].

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import '../widgets/catalogue_filter_chip.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

enum CatalogueCategory {
  fish(
    title: 'Fish',
    searchHint: 'Search fish...',
    emptyTitle: 'No fish found',
    icon: Icons.set_meal_rounded,
    accent: AppColors.primary,
    accentSoft: AppColors.primarySoft,
  ),
  chicken(
    title: 'Chicken',
    searchHint: 'Search chicken...',
    emptyTitle: 'No chicken found',
    icon: Icons.restaurant_rounded,
    accent: AppColors.chicken,
    accentSoft: AppColors.chickenSoft,
  );

  const CatalogueCategory({
    required this.title,
    required this.searchHint,
    required this.emptyTitle,
    required this.icon,
    required this.accent,
    required this.accentSoft,
  });

  final String title;
  final String searchHint;
  final String emptyTitle;
  final IconData icon;
  final Color accent;
  final Color accentSoft;
}

class CatalogueScreen extends StatefulWidget {
  final CatalogueCategory category;

  const CatalogueScreen({super.key, required this.category});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  static const List<(String, IconData?)> _filters = [
    ('All', null),
    ('Available', Icons.check_circle_outline_rounded),
    ('Unavailable', Icons.remove_circle_outline_rounded),
  ];

  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _searchQuery = '';

  CatalogueCategory get _category => widget.category;

  // Step 1 will replace this single line with the repository.
  List<Product> get _allProducts =>
      _category == CatalogueCategory.fish ? fishList : chickenList;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    var products = List<Product>.from(_allProducts);

    if (_selectedFilter == 'Available') {
      products = products.where((p) => p.isAvailable).toList();
    }

    if (_selectedFilter == 'Unavailable') {
      products = products.where((p) => !p.isAvailable).toList();
    }

    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      products = products
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    }

    return products;
  }

  void _openDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }

  Widget _section(double top, double bottom, Widget child) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20, top, 20, bottom),
      sliver: SliverToBoxAdapter(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _allProducts;
    final availableCount = all.where((p) => p.isAvailable).length;
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _section(16, 0, _buildHeader(all.length, availableCount)),
            _section(20, 0, _buildSearch()),
            _section(14, 0, _buildFilters()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
              sliver: products.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            accentColor: _category.accent,
                            fallbackIcon: _category.icon,
                            onTap: () => _openDetails(product),
                          );
                        },
                        childCount: products.length,
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

  Widget _buildHeader(int total, int availableCount) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _category.title,
                style: AppTextStyles.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 5),
              Text(
                '$total varieties • $availableCount available',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: _category.accentSoft,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(_category.icon, color: _category.accent, size: 23),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: _category.searchHint,
        prefixIcon: const Icon(Icons.search_rounded, size: 21),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                icon: const Icon(Icons.close_rounded, size: 19),
              )
            : null,
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final (label, icon) = _filters[index];
          return CatalogueFilterChip(
            label: label,
            icon: icon,
            selected: _selectedFilter == label,
            onTap: () => setState(() => _selectedFilter = label),
          );
        },
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
        border: Border.all(color: AppColors.border),
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
          Text(_category.emptyTitle, style: AppTextStyles.heading3),
          const SizedBox(height: 5),
          Text('Try a different search or filter.', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
