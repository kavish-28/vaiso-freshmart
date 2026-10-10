import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'login_type_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginTypeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildTopBar()),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildProfileCard()),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildSectionTitle('ACCOUNT')),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildAccountCard()),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildSectionTitle('APP')),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildAppCard()),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 35),
              sliver: SliverToBoxAdapter(child: _buildLogoutButton(context)),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // TOP BAR
  // ═════════════════════════════════════════════════

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: AppTextStyles.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 5),
              Text('Manage your account', style: AppTextStyles.body),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════
  // PROFILE CARD
  // ═════════════════════════════════════════════════

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(21),
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'user@email.com',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                SizedBox(height: 2),

                Text(
                  '+91 98765 43210',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),

          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // SECTION TITLE
  // ═════════════════════════════════════════════════

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }

  // ═════════════════════════════════════════════════
  // ACCOUNT
  // ═════════════════════════════════════════════════

  Widget _buildAccountCard() {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.person_outline_rounded,
          title: 'Personal information',
          subtitle: 'Name, email and phone',
          onTap: () {},
        ),

        _SettingsDivider(),

        _SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          subtitle: 'Manage app notifications',
          onTap: () {},
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════
  // APP
  // ═════════════════════════════════════════════════

  Widget _buildAppCard() {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'App preferences',
          onTap: () {},
        ),

        _SettingsDivider(),

        _SettingsTile(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'Fish & Chicken Price Viewer',
          onTap: () {},
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════
  // LOGOUT
  // ═════════════════════════════════════════════════

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: OutlinedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout_rounded, size: 19),
        label: const Text(
          'Log out',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: BorderSide(color: AppColors.danger.withOpacity(0.22)),
          backgroundColor: AppColors.dangerSoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// SETTINGS CARD
// ═══════════════════════════════════════════════════

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// ═══════════════════════════════════════════════════
// SETTINGS TILE
// ═══════════════════════════════════════════════════

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(23),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// DIVIDER
// ═══════════════════════════════════════════════════

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 70,
      endIndent: 15,
      color: AppColors.border,
    );
  }
}
