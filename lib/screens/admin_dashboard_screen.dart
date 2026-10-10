import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';
import 'login_type_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const _ink = AppColors.textPrimary;
  static const _paper = AppColors.surface;
  static const _sage = AppColors.textSecondary;
  static const _line = AppColors.border;
  int _selectedTab = 0;
  String _selectedCategory = 'All';
  String _query = '';

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

  void _showProductSheet({Product? product, String? initialCategory}) {
    final isEditing = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(
      text: product?.pricePerKg.toStringAsFixed(0) ?? '',
    );
    var category = product?.category ?? initialCategory ?? 'fish';
    var available = product?.isAvailable ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            top: 36,
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isEditing ? 'Edit product' : 'Add product',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Changes appear in the customer catalogue immediately.',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 24),
                    const Text('Product name', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Vanjaram',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Price per kg', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 850',
                        prefixText: '₹  ',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Category', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'fish',
                          label: Text('Fish'),
                          icon: Icon(Icons.set_meal_rounded),
                        ),
                        ButtonSegment(
                          value: 'chicken',
                          label: Text('Chicken'),
                          icon: Icon(Icons.restaurant_rounded),
                        ),
                      ],
                      selected: {category},
                      onSelectionChanged: (value) =>
                          setSheetState(() => category = value.first),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SwitchListTile.adaptive(
                        title: const Text(
                          'Available today',
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: Text(
                          available
                              ? 'Visible to customers'
                              : 'Shown as out of stock',
                        ),
                        value: available,
                        onChanged: (value) =>
                            setSheetState(() => available = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final price = double.tryParse(
                          priceController.text.trim(),
                        );
                        if (name.isEmpty || price == null || price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Enter a valid product name and price.',
                              ),
                            ),
                          );
                          return;
                        }
                        final updated = Product(
                          id: isEditing
                              ? product.id
                              : 'product_${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          pricePerKg: price,
                          isAvailable: available,
                          category: category,
                          imageUrl: isEditing && product.category == category
                              ? product.imageUrl
                              : category == 'fish'
                              ? 'assets/images/vanjaram.jpg'
                              : 'assets/images/broiler_chicken.jpg',
                        );
                        if (isEditing) {
                          _replaceProduct(product, updated);
                        } else {
                          setState(() {
                            if (category == 'fish') {
                              fishList.add(updated);
                            } else {
                              chickenList.add(updated);
                            }
                          });
                        }
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing ? 'Product updated' : 'Product added',
                            ),
                          ),
                        );
                      },
                      child: Text(isEditing ? 'Save changes' : 'Add product'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      nameController.dispose();
      priceController.dispose();
    });
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
              onPressed: () => _showProductSheet(),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add product'),
            )
          : null,
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 760
          ? _AdminBottomNav(
              currentIndex: _selectedTab,
              onChanged: (index) => setState(() => _selectedTab = index),
            )
          : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            return Row(
              children: [
                if (wide) _adminRail(),
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

  Widget _adminRail() => NavigationRail(
    backgroundColor: AppColors.surface,
    selectedIndex: _selectedTab,
    onDestinationSelected: (index) => setState(() => _selectedTab = index),
    labelType: NavigationRailLabelType.all,
    leading: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
      ),
    ),
    destinations: const [
      NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard_rounded),
        label: Text('Dashboard'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2_rounded),
        label: Text('Products'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.price_change_outlined),
        selectedIcon: Icon(Icons.price_change_rounded),
        label: Text('Daily prices'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.fact_check_outlined),
        selectedIcon: Icon(Icons.fact_check_rounded),
        label: Text('Stock'),
      ),
    ],
  );

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

  Widget _dashboardPage(int available, int unavailable) => LayoutBuilder(
    builder: (context, constraints) => _scrollPage([
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        sliver: SliverToBoxAdapter(child: _header()),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        sliver: SliverToBoxAdapter(child: _dashboardHero(available)),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        sliver: SliverToBoxAdapter(
          child: _summary(available, unavailable, constraints.maxWidth),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        sliver: SliverToBoxAdapter(child: _dashboardQuickActions()),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 110),
        sliver: SliverToBoxAdapter(child: _priceHighlights()),
      ),
    ]),
  );

  Widget _productsPage() => _scrollPage([
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      sliver: SliverToBoxAdapter(
        child: _pageHeading(
          'Product management',
          'Add, edit and manage your fish & chicken catalogue.',
          Icons.inventory_2_rounded,
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      sliver: SliverToBoxAdapter(child: _catalogueToolbar()),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      sliver: _productGridSliver(),
    ),
  ]);

  Widget _productGridSliver() => _visibleProducts.isEmpty
      ? const SliverToBoxAdapter(child: _EmptyProducts())
      : SliverGrid.builder(
          itemCount: _visibleProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final product = _visibleProducts[index];
            return _AdminProductTile(
              product: product,
              onEdit: () => _showProductSheet(product: product),
              onAvailabilityChanged: (value) => _replaceProduct(
                product,
                product.copyWith(isAvailable: value),
              ),
            );
          },
        );

  Widget _dailyPricesPage() => _scrollPage([
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      sliver: SliverToBoxAdapter(
        child: _pageHeading(
          'Daily prices',
          'Keep today’s market rates fresh for customers.',
          Icons.price_change_rounded,
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      sliver: SliverToBoxAdapter(child: _catalogueToolbar()),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      sliver: _priceListSliver(),
    ),
  ]);

  Widget _stockPage() => _scrollPage([
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      sliver: SliverToBoxAdapter(
        child: _pageHeading(
          'Stock management',
          'Switch product availability as your counter changes.',
          Icons.fact_check_rounded,
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      sliver: SliverToBoxAdapter(child: _stockSummary()),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      sliver: SliverToBoxAdapter(child: _catalogueToolbar()),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      sliver: _stockListSliver(),
    ),
  ]);

  Widget _pageHeading(String title, String subtitle, IconData icon) => Row(
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: AppColors.primary, size: 23),
      ),
      const SizedBox(width: 13),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.heading2),
            const SizedBox(height: 3),
            Text(subtitle, style: AppTextStyles.caption),
          ],
        ),
      ),
    ],
  );

  Widget _dashboardHero(int available) {
    final total = _products.length;
    return Container(
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary, Color(0xFF168BCE)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -50,
            bottom: -125,
            child: Container(
              width: 245,
              height: 245,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.065),
              ),
            ),
          ),
          Positioned(
            right: -56,
            top: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.aqua.withOpacity(.18),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: -5,
            child: Icon(
              Icons.inventory_2_rounded,
              size: 116,
              color: Colors.white.withOpacity(.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 17, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(.16)),
                  ),
                  child: const Text(
                    'FRESHMART  /  ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your counter,\nat a glance.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.04,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.55,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF63E6B1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '$available products available today',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.88),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 17,
            top: 17,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.14),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.white.withOpacity(.15)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$total items',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardQuickActions() => Column(
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
          _QuickActionCard(
            label: 'Add fish',
            icon: Icons.set_meal_rounded,
            color: AppColors.primary,
            onTap: () => _showProductSheet(initialCategory: 'fish'),
          ),
          _QuickActionCard(
            label: 'Add chicken',
            icon: Icons.restaurant_rounded,
            color: const Color(0xFFE87922),
            onTap: () => _showProductSheet(initialCategory: 'chicken'),
          ),
          _QuickActionCard(
            label: 'Daily prices',
            icon: Icons.price_change_rounded,
            color: AppColors.aqua,
            onTap: () => setState(() => _selectedTab = 2),
          ),
          _QuickActionCard(
            label: 'Manage stock',
            icon: Icons.fact_check_rounded,
            color: AppColors.success,
            onTap: () => setState(() => _selectedTab = 3),
          ),
        ],
      ),
    ],
  );

  Widget _priceHighlights() {
    final highlights = [...fishList.take(2), ...chickenList.take(2)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Today’s prices', style: AppTextStyles.heading2),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedTab = 2),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...highlights.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _AdminPriceRow(
              product: product,
              onEdit: () => _showProductSheet(product: product),
            ),
          ),
        ),
      ],
    );
  }

  SliverList _priceListSliver() => SliverList.separated(
    itemCount: _visibleProducts.length,
    itemBuilder: (context, index) {
      final product = _visibleProducts[index];
      return _AdminPriceRow(
        product: product,
        onEdit: () => _showProductSheet(product: product),
      );
    },
    separatorBuilder: (_, __) => const SizedBox(height: 10),
  );

  Widget _stockSummary() {
    final available = _products.where((product) => product.isAvailable).length;
    final unavailable = _products.length - available;
    return Row(
      children: [
        Expanded(
          child: _StockCountCard(
            label: 'Available',
            value: available.toString(),
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _StockCountCard(
            label: 'Out of stock',
            value: unavailable.toString(),
            icon: Icons.remove_shopping_cart_outlined,
            color: AppColors.danger,
          ),
        ),
      ],
    );
  }

  SliverList _stockListSliver() => SliverList.separated(
    itemCount: _visibleProducts.length,
    itemBuilder: (context, index) {
      final product = _visibleProducts[index];
      return _AdminStockRow(
        product: product,
        onChanged: (value) =>
            _replaceProduct(product, product.copyWith(isAvailable: value)),
      );
    },
    separatorBuilder: (_, __) => const SizedBox(height: 10),
  );

  Widget _header() {
    final now = DateTime.now();
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final greeting = now.hour < 12
        ? 'Good morning, Admin'
        : now.hour < 17
        ? 'Good afternoon, Admin'
        : 'Good evening, Admin';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              const Text('Shop dashboard', style: AppTextStyles.heading2),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.circle, size: 7, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Updated today · ${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _paper,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _logout,
            tooltip: 'Log out',
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.primary,
              size: 21,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summary(int available, int unavailable, double width) {
    final stats = [
      ('TOTAL CUTS', '${_products.length}', Icons.inventory_2_outlined, _ink),
      (
        'AVAILABLE',
        '$available',
        Icons.check_circle_outline_rounded,
        AppColors.success,
      ),
      (
        'NEEDS RESTOCK',
        '$unavailable',
        Icons.remove_shopping_cart_outlined,
        AppColors.danger,
      ),
      ('CATEGORIES', '02', Icons.grid_view_rounded, AppColors.aqua),
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
      itemBuilder: (_, index) => _PremiumStatCard(
        label: stats[index].$1,
        value: stats[index].$2,
        icon: stats[index].$3,
        color: stats[index].$4,
      ),
    );
  }

  Widget _catalogueToolbar() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: 'Find a cut or catch...',
          prefixIcon: const Icon(Icons.search_rounded, color: _sage),
          filled: true,
          fillColor: _paper,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: _line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: _sage, width: 1.4),
          ),
        ),
      ),
      const SizedBox(height: 13),
      Wrap(
        spacing: 8,
        children: ['All', 'Fish', 'Chicken']
            .map(
              (label) => ChoiceChip(
                label: Text(label.toUpperCase()),
                selected: _selectedCategory == label,
                onSelected: (_) => setState(() => _selectedCategory = label),
                showCheckmark: false,
                labelStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                  color: _selectedCategory == label ? Colors.white : _ink,
                ),
                selectedColor: _ink,
                backgroundColor: _paper,
                side: BorderSide(
                  color: _selectedCategory == label ? _ink : _line,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

// PREMIUM STAT CARD WITH GLASSMORPHISM
class _AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _AdminBottomNav({required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) => SafeArea(
    minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
    child: Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.96),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.07),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _AdminNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            selected: currentIndex == 0,
            onTap: () => onChanged(0),
          ),
          _AdminNavItem(
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2_rounded,
            label: 'Products',
            selected: currentIndex == 1,
            onTap: () => onChanged(1),
          ),
          _AdminNavItem(
            icon: Icons.price_change_outlined,
            activeIcon: Icons.price_change_rounded,
            label: 'Prices',
            selected: currentIndex == 2,
            onTap: () => onChanged(2),
          ),
          _AdminNavItem(
            icon: Icons.fact_check_outlined,
            activeIcon: Icons.fact_check_rounded,
            label: 'Stock',
            selected: currentIndex == 3,
            onTap: () => onChanged(3),
          ),
        ],
      ),
    ),
  );
}

class _AdminNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AdminNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Column(
              key: ValueKey(selected),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? activeIcon : icon,
                  size: 21,
                  color: selected ? AppColors.primary : AppColors.textMuted,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// Premium stat card with the same surface, border and type scale as customer cards.
class _PremiumStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _PremiumStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: _AdminDashboardScreenState._paper,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: _AdminDashboardScreenState._line),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.035),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          right: -20,
          top: -24,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.045),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color, color.withOpacity(.35)],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(13, 12, 11, 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(.16), color.withOpacity(.07)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(.12)),
                ),
                child: Icon(icon, color: color, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 25,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.8,
                        color: _AdminDashboardScreenState._ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .55,
                        color: _AdminDashboardScreenState._sage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AdminProductTile extends StatefulWidget {
  final Product product;
  final VoidCallback onEdit;
  final ValueChanged<bool> onAvailabilityChanged;

  const _AdminProductTile({
    required this.product,
    required this.onEdit,
    required this.onAvailabilityChanged,
  });

  @override
  State<_AdminProductTile> createState() => _AdminProductTileState();
}

class _AdminProductTileState extends State<_AdminProductTile>
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
              color: Colors.black.withOpacity(.035),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
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
                          color: Colors.white.withOpacity(.92),
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
                          color: Colors.white.withOpacity(.94),
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 5, 8, 5),
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
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${widget.product.pricePerKg.toStringAsFixed(0)} / kg',
                            maxLines: 1,
                            style: AppTextStyles.price.copyWith(
                              fontSize: 15,
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
                        width: 30,
                        height: 30,
                      ),
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceSoft,
                        foregroundColor: AppColors.primary,
                      ),
                      icon: const Icon(Icons.edit_rounded, size: 15),
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

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.025),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    ),
  );
}

class _AdminPriceRow extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;

  const _AdminPriceRow({required this.product, required this.onEdit});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.025),
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

class _AdminStockRow extends StatelessWidget {
  final Product product;
  final ValueChanged<bool> onChanged;

  const _AdminStockRow({required this.product, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.025),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: ProductImage(
            imageUrl: product.imageUrl,
            width: 54,
            height: 54,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.isAvailable ? 'Available today' : 'Out of stock',
                style: AppTextStyles.caption.copyWith(
                  color: product.isAvailable
                      ? AppColors.success
                      : AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: product.isAvailable,
          activeThumbColor: AppColors.success,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

class _StockCountCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StockCountCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.heading3.copyWith(fontSize: 18)),
              Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

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
