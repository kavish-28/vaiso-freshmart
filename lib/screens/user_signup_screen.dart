import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'main_nav_screen.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    // Firebase Auth + Firestore profile creation will be connected here.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _isLoading = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -130,
              right: -100,
              child: _DecorativeCircle(
                size: 290,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              bottom: -130,
              left: -100,
              child: _DecorativeCircle(
                size: 300,
                color: AppColors.aqua.withValues(alpha: 0.08),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(22, 16, 22, 28 + bottomInset),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 34),
                      _buildHeader(),
                      const SizedBox(height: 28),
                      _buildForm(),
                      const SizedBox(height: 22),
                      _buildLoginPrompt(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() => Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(15),
              child: Ink(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 21,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(children: [
            Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Image.asset('assets/images/logo_fish.png'),
            ),
            const SizedBox(width: 9),
            Text('FreshMart',
                style: AppTextStyles.heading3.copyWith(fontSize: 15)),
          ]),
        ],
      );

  Widget _buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'CREATE ACCOUNT',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 17),
          Text('Fresh prices,\njust for you.',
              style: AppTextStyles.display.copyWith(fontSize: 35)),
          const SizedBox(height: 12),
          Text(
            'Create an account to access today’s fish & chicken catalogue.',
            style: AppTextStyles.body.copyWith(fontSize: 14.5, height: 1.55),
          ),
        ],
      );

  Widget _buildForm() => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Full name'),
            _field(
              controller: _nameController,
              hint: 'Enter your name',
              icon: Icons.person_outline_rounded,
              action: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            _space(),
            _label('Mobile number'),
            _field(
              controller: _phoneController,
              hint: 'Enter your mobile number',
              icon: Icons.phone_outlined,
              action: TextInputAction.next,
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.trim().length < 10
                  ? 'Please enter a valid mobile number'
                  : null,
            ),
            _space(),
            _label('Email address'),
            _field(
              controller: _emailController,
              hint: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              action: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || !value.contains('@')
                  ? 'Please enter a valid email'
                  : null,
            ),
            _space(),
            _label('Password'),
            _passwordField(
              controller: _passwordController,
              hint: 'Create a password',
              obscure: _obscurePassword,
              onVisibilityTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              validator: (value) => value == null || value.length < 6
                  ? 'Password must contain at least 6 characters'
                  : null,
            ),
            _space(),
            _label('Confirm password'),
            _passwordField(
              controller: _confirmPasswordController,
              hint: 'Confirm your password',
              obscure: _obscureConfirmPassword,
              onVisibilityTap: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              action: TextInputAction.done,
              onSubmitted: (_) => _createAccount(),
              validator: (value) => value != _passwordController.text
                  ? 'Passwords do not match'
                  : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createAccount,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Create account'),
              ),
            ),
          ],
        ),
      );

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Text(text, style: AppTextStyles.bodyMedium),
      );

  Widget _space() => const SizedBox(height: 18);

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FormFieldValidator<String> validator,
    required TextInputAction action,
    TextInputType? keyboardType,
  }) => TextFormField(
        controller: controller,
        textInputAction: action,
        keyboardType: keyboardType,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
        ),
        validator: validator,
      );

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onVisibilityTap,
    required FormFieldValidator<String> validator,
    TextInputAction action = TextInputAction.next,
    ValueChanged<String>? onSubmitted,
  }) => TextFormField(
        controller: controller,
        obscureText: obscure,
        textInputAction: action,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
          suffixIcon: IconButton(
            onPressed: onVisibilityTap,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
          ),
        ),
        validator: validator,
      );

  Widget _buildLoginPrompt() => Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Already have an account? ', style: AppTextStyles.body),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sign in'),
            ),
          ],
        ),
      );
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorativeCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      );
}
