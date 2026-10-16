import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/sample_data.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onFishTap;
  final VoidCallback onChickenTap;

  const HomeScreen({
    super.key,
    required this.onFishTap,
    required this.onChickenTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = [
      ...fishList,
      ...chickenList,
    ];

    final availableCount =
        allProducts.where((product) => product.isAvailable).length;

    final outOfStockCount =
        allProducts.where((product) => !product.isAvailable).length;

    final totalCount = allProducts.length;

    final availabilityPercentage = totalCount == 0
        ? 0
        : ((availableCount / totalCount) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await Future.delayed(
                  const Duration(milliseconds: 600),
                );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  30,
                ),
                children: [
                  _buildHeader(),

                  const SizedBox(height: 24),

                  _buildHeroBanner(),

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    title: 'Check today’s prices',
                    subtitle: 'Choose a category',
                  ),

                  const SizedBox(height: 14),

                  _buildCategorySection(),

                  const SizedBox(height: 28),

                  _buildAvailabilitySection(
                    availableCount: availableCount,
                    outOfStockCount: outOfStockCount,
                    percentage: availabilityPercentage,
                  ),

                  const SizedBox(height: 26),

                  _buildInfoCard(),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    final hour = DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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

              const SizedBox(height: 4),

              const Text(
                'Fresh prices, at a glance.',
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    'Updated today',
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

        _buildProfileButton(),
      ],
    );
  }

  Widget _buildProfileButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.primary,
        size: 23,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HERO
  // ─────────────────────────────────────────────

  Widget _buildHeroBanner() {
    final totalProducts = fishList.length + chickenList.length;
    final availableProducts = [
      ...fishList,
      ...chickenList,
    ].where((product) => product.isAvailable).length;

    return Container(
      height: 188,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B3FAE),
            Color(0xFF1261FF),
            Color(0xFF168BCE),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Abstract visual layers — intentionally image-free.
          Positioned(
            left: -50,
            bottom: -90,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: -54,
            top: -60,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.aqua.withValues(alpha: 0.16),
              ),
            ),
          ),

          Positioned(
            right: 5,
            bottom: 6,
            child: Transform.rotate(
              angle: -0.32,
              child: Icon(
                Icons.waves_rounded,
                size: 118,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Text
          Positioned(
            left: 20,
            top: 22,
            right: 142,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                  child: const Text(
                    'MARKET PULSE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Fresh prices,\nright now.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  'Updated daily for your\nlocal market.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          // A data-driven signal card gives the banner a distinctive look
          // without product photography.
          Positioned(
            right: 16,
            top: 18,
            child: _MarketPulseCard(
              totalProducts: totalProducts,
              availableProducts: availableProducts,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heading2.copyWith(
                  fontSize: 19,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),

        const Icon(
          Icons.arrow_forward_rounded,
          color: AppColors.textMuted,
          size: 19,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CATEGORY CARDS
  // ─────────────────────────────────────────────

  Widget _buildCategorySection() {
    return Row(
      children: [
        Expanded(
          child: _CategoryCard(
            title: 'Fish',
            subtitle: '${fishList.length} varieties',
            imagePath: 'assets/images/vanjaram.jpg',
            accentColor: AppColors.primary,
            icon: Icons.set_meal_rounded,
            onTap: widget.onFishTap,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _CategoryCard(
            title: 'Chicken',
            subtitle: '${chickenList.length} varieties',
            imagePath: 'assets/images/broiler_chicken.jpg',
            accentColor: const Color(0xFFE87922),
            icon: Icons.restaurant_rounded,
            onTap: widget.onChickenTap,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // AVAILABILITY
  // ─────────────────────────────────────────────

  Widget _buildAvailabilitySection({
    required int availableCount,
    required int outOfStockCount,
    required int percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.success,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today’s availability',
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$availableCount of ${availableCount + outOfStockCount} items available',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              Text(
                '$percentage%',
                style: AppTextStyles.price.copyWith(
                  fontSize: 21,
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.success,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  value: '$availableCount',
                  label: 'Available',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success,
                ),
              ),

              Container(
                width: 1,
                height: 32,
                color: AppColors.border,
              ),

              Expanded(
                child: _MiniStat(
                  value: '$outOfStockCount',
                  label: 'Out of stock',
                  icon: Icons.remove_circle_outline_rounded,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // INFO CARD
  // ─────────────────────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              'Prices and availability may change during the day. '
              'Check back for the latest update.',
              style: AppTextStyles.caption.copyWith(
                height: 1.45,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// MARKET PULSE CARD
// ═══════════════════════════════════════════════════

class _MarketPulseCard extends StatelessWidget {
  final int totalProducts;
  final int availableProducts;

  const _MarketPulseCard({
    required this.totalProducts,
    required this.availableProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 152,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: AppColors.aqua,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '$availableProducts',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w900,
              height: 0.9,
              letterSpacing: -1.3,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'OF $totalProducts AVAILABLE',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.55,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _signalBar(14, 0.45),
              const SizedBox(width: 4),
              _signalBar(22, 0.7),
              const SizedBox(width: 4),
              _signalBar(30, 1),
              const SizedBox(width: 4),
              _signalBar(19, 0.6),
              const SizedBox(width: 4),
              _signalBar(26, 0.82),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signalBar(double height, double opacity) => Container(
        width: 9,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.aqua.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(20),
        ),
      );
}

// ═══════════════════════════════════════════════════
// CATEGORY CARD
// ═══════════════════════════════════════════════════

class _CategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.accentColor,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  void _tap() {
    setState(() => _pressed = true);

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (mounted) {
          setState(() => _pressed = false);
        }
      },
    );

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 110),
      child: GestureDetector(
        onTap: _tap,
        child: Container(
          height: 194,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 116,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Container(
                      color: AppColors.surfaceSoft,
                      child: Icon(
                        widget.icon,
                        size: 42,
                        color: widget.accentColor,
                      ),
                    );
                  },
                ),
              ),

              // Image gradient
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                height: 66,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.38),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Small category icon
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.accentColor,
                    size: 17,
                  ),
                ),
              ),

              // Bottom information
              Positioned(
                left: 15,
                right: 13,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: AppTextStyles.heading3.copyWith(
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            widget.subtitle,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: widget.accentColor,
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// MINI STAT
// ═══════════════════════════════════════════════════

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 19,
        ),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 16,
              ),
            ),

            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
