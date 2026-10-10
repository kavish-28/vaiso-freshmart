import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'chicken_screen.dart';
import 'fish_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int currentIndex = 0;

  void _goToTab(int index) {
    if (currentIndex == index) return;

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onFishTap: () => _goToTab(1),
        onChickenTap: () => _goToTab(2),
      ),
      const FishScreen(),
      const ChickenScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: _ModernBottomNav(
        currentIndex: currentIndex,
        onChanged: _goToTab,
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// MODERN BOTTOM NAVIGATION
// ═══════════════════════════════════════════════════

class _ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _ModernBottomNav({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        10,
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
              selected: currentIndex == 0,
              onTap: () => onChanged(0),
            ),

            _NavItem(
              icon: Icons.set_meal_outlined,
              activeIcon: Icons.set_meal_rounded,
              label: 'Fish',
              selected: currentIndex == 1,
              onTap: () => onChanged(1),
            ),

            _NavItem(
              icon: Icons.restaurant_outlined,
              activeIcon: Icons.restaurant_rounded,
              label: 'Chicken',
              selected: currentIndex == 2,
              onTap: () => onChanged(2),
            ),

            _NavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
              selected: currentIndex == 3,
              onTap: () => onChanged(3),
            ),
          ],
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// NAV ITEM
// ═══════════════════════════════════════════════════

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primarySoft
                  : Colors.transparent,
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
                    color: selected
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: selected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textMuted,
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
}