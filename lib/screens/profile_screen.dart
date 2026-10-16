import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'login_type_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Doe';
  String _email = 'user@email.com';
  String _phone = '+91 98765 43210';
  bool _notificationsEnabled = true;

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginTypeScreen()),
      (route) => false,
    );
  }

  void _showMessage(String title, String message, IconData icon) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text(title, style: AppTextStyles.heading3),
            const SizedBox(height: 7),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    final name = TextEditingController(text: _name);
    final email = TextEditingController(text: _email);
    final phone = TextEditingController(text: _phone);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)))),
                const SizedBox(height: 22),
                const Text('Personal information', style: AppTextStyles.heading2),
                const SizedBox(height: 5),
                Text('Keep your account details up to date.', style: AppTextStyles.body),
                const SizedBox(height: 20),
                const Text('Name', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 7),
                TextField(controller: name, textCapitalization: TextCapitalization.words),
                const SizedBox(height: 14),
                const Text('Email', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 7),
                TextField(controller: email, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 14),
                const Text('Phone number', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 7),
                TextField(controller: phone, keyboardType: TextInputType.phone),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (name.text.trim().isEmpty || email.text.trim().isEmpty) return;
                      setState(() {
                        _name = name.text.trim();
                        _email = email.text.trim();
                        _phone = phone.text.trim();
                      });
                      Navigator.pop(sheetContext);
                    },
                    child: const Text('Save changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() { name.dispose(); email.dispose(); phone.dispose(); });
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
            color: Colors.black.withValues(alpha: 0.08),
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
            child: Center(
              child: Text(
                _name
                    .split(' ')
                    .where((part) => part.isNotEmpty)
                    .take(2)
                    .map((part) => part[0])
                    .join()
                    .toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  _email,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                SizedBox(height: 2),

                Text(
                  _phone,
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: _editProfile,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 16,
              ),
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
          onTap: _editProfile,
        ),

        _SettingsDivider(),

        _SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          subtitle: _notificationsEnabled
              ? 'Notifications are on'
              : 'Notifications are paused',
          onTap: () => setState(
            () => _notificationsEnabled = !_notificationsEnabled,
          ),
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
          onTap: () => _showMessage(
            'App preferences',
            'Your preference controls will appear here as the app grows.',
            Icons.tune_rounded,
          ),
        ),

        _SettingsDivider(),

        _SettingsTile(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'Fish & Chicken Price Viewer',
          onTap: () => _showMessage(
            'About FreshMart',
            'A simple way to check today’s fish and chicken prices.',
            Icons.info_outline_rounded,
          ),
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
          side: BorderSide(color: AppColors.danger.withValues(alpha: 0.22)),
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
