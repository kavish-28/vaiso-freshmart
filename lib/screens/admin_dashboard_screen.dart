import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import 'admin/admin_header.dart';
import 'admin/admin_navigation.dart';
import 'admin/admin_overview_sections.dart';
import 'admin/admin_product_sheet.dart';
import 'admin/admin_product_tiles.dart';
import 'admin/admin_toolbar.dart';
import 'login_type_screen.dart';

/// Admin shell: owns the selected tab, search text and category filter,
/// and composes the pages from the widgets in `screens/admin/`.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0;
  String _selectedCategory = 'All';
  String _query = '';

  // Step 1 will replace these list accesses with the repository.
  List<Product> get _products => [...fishList, ...chickenList];

  List<Product> get _visibleProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          product.category == _selectedCategory.toLowerCase();
      return matchesCategory &&
          product.name.toLowerCase().contains(_query.trim().toLowerCase());
    }).toList();
  }

  void _goToTab(int index) => setState(() => _selectedTab = index);

  void _replaceProduct(Product oldProduct, Product newProduct) {
    final oldList = oldProduct.category == 'fish' ? fishList : chickenList;
    final newList = newProduct.category == 'fish' ? fishList : chickenList;
    final index = oldList.indexOf(oldProduct);

    if (index == -1) return;

    setState(() {
      if (identical(oldList, newList)) {
        oldList[index] = newProduct;
      } else {
        oldList.removeAt(index);
        newList.add(newProduct);
      }
    });
  }

  void _handleSaved(Product updated, Product? original) {
    if (original != null) {
      _replaceProduct(original, updated);
      return;
    }
    setState(() {
      (updated.category == 'fish' ? fishList : chickenList).add(updated);
    });
  }

  void _openProductSheet({Product? product, String? initialCategory}) {
    showAdminProductSheet(
      context,
      product: product,
      initialCategory: initialCategory,
      onSaved: _handleSaved,
    );
  }

  void _setAvailability(Product product, bool value) {
    _replaceProduct(product, product.copyWith(isAvailable: value));
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginTypeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final available = _products.where((p) => p.isAvailable).length;
    final unavailable = _products.length - available;
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      floatingActionButton: _selectedTab <= 1
          ? FloatingActionButton.extended(
              onPressed: () => _openProductSheet(),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add product'),
            )
          : null,
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 760
          ? AdminBottomNav(currentIndex: _selectedTab, onChanged: _goToTab)
          : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            return Row(
              children: [
                if (wide)
                  AdminNavRail(
                    selectedIndex: _selectedTab,
                    onSelected: _goToTab,
                  ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: switch (_selectedTab) {
                      1 => _productsPage(),
                      2 => _dailyPricesPage(),
                      3 => _stockPage(),
                      _ => _dashboardPage(available, unavailable),
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────── page helpers ─────────────────────────

  Widget _scrollPage(List<Widget> slivers) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: CustomScrollView(
        key: ValueKey(_selectedTab),
        physics: const BouncingScrollPhysics(),
        slivers: slivers,
      ),
    ),
  );

  Widget _padded(double top, double bottom, Widget child) => SliverPadding(
    padding: EdgeInsets.fromLTRB(20, top, 20, bottom),
    sliver: SliverToBoxAdapter(child: child),
  );

  Widget _toolbar() => AdminCatalogueToolbar(
    selectedCategory: _selectedCategory,
    onQueryChanged: (value) => setState(() => _query = value),
    onCategoryChanged: (label) => setState(() => _selectedCategory = label),
  );

  Widget _tileGrid(
    Widget Function(Product product) tileBuilder, {
    bool showEmptyState = false,
  }) {
    final products = _visibleProducts;
    if (showEmptyState && products.isEmpty) {
      return const SliverToBoxAdapter(child: AdminEmptyProducts());
    }
    return SliverGrid.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => tileBuilder(products[index]),
    );
  }

  // ───────────────────────── pages ─────────────────────────

  Widget _dashboardPage(int available, int unavailable) => LayoutBuilder(
    builder: (context, constraints) => _scrollPage([
      _padded(18, 0, AdminHeader(onLogout: _logout)),
      _padded(20, 0, AdminHero(available: available, total: _products.length)),
      _padded(
        20,
        0,
        AdminSummaryGrid(
          total: _products.length,
          available: available,
          unavailable: unavailable,
          width: constraints.maxWidth,
        ),
      ),
      _padded(
        30,
        0,
        AdminQuickActions(
          onAddFish: () => _openProductSheet(initialCategory: 'fish'),
          onAddChicken: () => _openProductSheet(initialCategory: 'chicken'),
          onOpenPrices: () => _goToTab(2),
          onOpenStock: () => _goToTab(3),
        ),
      ),
      _padded(
        28,
        110,
        AdminPriceHighlights(
          products: [...fishList.take(2), ...chickenList.take(2)],
          onSeeAll: () => _goToTab(2),
          onEdit: (product) => _openProductSheet(product: product),
        ),
      ),
    ]),
  );

  Widget _productsPage() => _scrollPage([
    _padded(
      22,
      0,
      const AdminPageHeading(
        title: 'Product management',
        subtitle: 'Add, edit and manage your fish & chicken catalogue.',
        icon: Icons.inventory_2_rounded,
      ),
    ),
    _padded(22, 0, _toolbar()),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      sliver: _tileGrid(
        showEmptyState: true,
        (product) => AdminProductTile(
          product: product,
          onEdit: () => _openProductSheet(product: product),
          onAvailabilityChanged: (value) => _setAvailability(product, value),
        ),
      ),
    ),
  ]);

  Widget _dailyPricesPage() => _scrollPage([
    _padded(
      22,
      0,
      const AdminPageHeading(
        title: 'Daily prices',
        subtitle: 'Keep today’s market rates fresh for customers.',
        icon: Icons.price_change_rounded,
      ),
    ),
    _padded(20, 0, _toolbar()),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      sliver: _tileGrid(
        (product) => AdminManagementTile(
          product: product,
          mode: ManagementTileMode.price,
          onEdit: () => _openProductSheet(product: product),
          onAvailabilityChanged: (value) => _setAvailability(product, value),
        ),
      ),
    ),
  ]);

  Widget _stockPage() {
    final available = _products.where((p) => p.isAvailable).length;
    return _scrollPage([
      _padded(
        22,
        0,
        const AdminPageHeading(
          title: 'Stock management',
          subtitle: 'Switch product availability as your counter changes.',
          icon: Icons.fact_check_rounded,
        ),
      ),
      _padded(
        18,
        0,
        AdminStockSummary(
          available: available,
          unavailable: _products.length - available,
        ),
      ),
      _padded(20, 0, _toolbar()),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        sliver: _tileGrid(
          (product) => AdminManagementTile(
            product: product,
            mode: ManagementTileMode.stock,
            onEdit: () => _openProductSheet(product: product),
            onAvailabilityChanged: (value) => _setAvailability(product, value),
          ),
        ),
      ),
    ]);
  }
}
