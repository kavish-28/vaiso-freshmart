import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'admin_login_screen.dart';
import 'user_login_screen.dart';
import 'user_signup_screen.dart';

class LoginTypeScreen extends StatefulWidget {
  const LoginTypeScreen({super.key});

  @override
  State<LoginTypeScreen> createState() => _LoginTypeScreenState();
}

class _LoginTypeScreenState extends State<LoginTypeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
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

  void _openUserLogin() {
    Navigator.push(
      context,
      _smoothRoute(
        const UserLoginScreen(),
      ),
    );
  }

  void _openAdminLogin() {
    Navigator.push(
      context,
      _smoothRoute(
        const AdminLoginScreen(),
      ),
    );
  }

  void _openSignup() {
    Navigator.push(
      context,
      _smoothRoute(
        const UserSignupScreen(),
      ),
    );
  }

  PageRouteBuilder _smoothRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative shapes
            Positioned(
              top: -120,
              right: -100,
              child: _BlurCircle(
                size: 280,
                color: AppColors.primary.withValues(alpha: 0.09),
              ),
            ),

            Positioned(
              bottom: -140,
              left: -100,
              child: _BlurCircle(
                size: 300,
                color: AppColors.aqua.withValues(alpha: 0.09),
              ),
            ),

            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.paddingOf(context).top -
                      MediaQuery.paddingOf(context).bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    18,
                    22,
                    24,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _contentSlideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top brand
                          _buildBrand(),

                          const SizedBox(height: 38),

                          // Hero section
                          _buildHero(),

                          const SizedBox(height: 34),

                          // User card
                          _LoginOptionCard(
                            icon: Icons.person_rounded,
                            iconBackground: AppColors.primarySoft,
                            iconColor: AppColors.primary,
                            eyebrow: 'CUSTOMER',
                            title: 'Check today’s prices',
                            description:
                                'View fresh fish & chicken prices and availability.',
                            buttonText: 'Continue as Customer',
                            onTap: _openUserLogin,
                          ),

                          const SizedBox(height: 4),

                          Center(
                            child: TextButton(
                              onPressed: _openSignup,
                              child: const Text(
                                'New customer? Create account',
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Admin card
                          _LoginOptionCard(
                            icon: Icons.dashboard_rounded,
                            iconBackground: AppColors.aquaSoft,
                            iconColor: AppColors.aqua,
                            eyebrow: 'MANAGEMENT',
                            title: 'Manage FreshMart',
                            description:
                                'Update products, prices and stock availability.',
                            buttonText: 'Continue as Admin',
                            onTap: _openAdminLogin,
                          ),

                          const SizedBox(height: 28),

                          // Footer
                          Center(
                            child: Text(
                              'Fresh • Daily • Local',
                              style: AppTextStyles.caption.copyWith(
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Center(
                            child: Text(
                              'FreshMart',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/logo_fish.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FreshMart',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Fish & Chicken',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Small status pill
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppColors.successSoft,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'TODAY’S MARKET',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Freshness starts\nwith knowing.',
          style: AppTextStyles.display.copyWith(
            fontSize: 36,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          'Check today’s fish & chicken prices, '
          'see what’s available and stay updated.',
          style: AppTextStyles.body.copyWith(
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _LoginOptionCard extends StatefulWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String eyebrow;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const _LoginOptionCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  State<_LoginOptionCard> createState() => _LoginOptionCardState();
}

class _LoginOptionCardState extends State<_LoginOptionCard> {
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
    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(26),
          child: Ink(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: widget.iconBackground,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 24,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.textPrimary,
                        size: 19,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 19),

                Text(
                  widget.eyebrow,
                  style: AppTextStyles.caption.copyWith(
                    color: widget.iconColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  widget.title,
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 19,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  widget.description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 17),

                Row(
                  children: [
                    Text(
                      widget.buttonText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: widget.iconColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: widget.iconColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
