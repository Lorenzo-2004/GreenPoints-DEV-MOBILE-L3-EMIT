import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/user/user_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepository()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
    }
  }

  void _handleGoogleLogin() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<UserCubit>().refresh();
          context.go('/home');
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Décoration de fond
              Positioned(
                top: -80,
                right: -60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.03),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),

                      // Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            'assets/images/logo/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ).animate().scale(
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      ),

                      const SizedBox(height: 32),

                      // Titre
                      Text(
                        'Bienvenue\nsur',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: -0.5,
                          height: 1.3,
                        ),
                      ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Green',
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: 'Points',
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: AppColors.warning,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: 150.ms).fadeIn().scale(begin: const Offset(0.95, 0.95)),

                      const SizedBox(height: 48),

                      // Formulaire
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email
                            _buildModernInput(
                              controller: _emailCtrl,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              hint: 'exemple@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@') ? 'Email invalide' : null,
                              delay: 250.ms,
                            ),
                            const SizedBox(height: 20),
                            // Mot de passe
                            _buildModernInput(
                              controller: _passCtrl,
                              label: 'Mot de passe',
                              icon: Icons.lock_outline,
                              hint: 'Ton mot de passe',
                              obscure: _obscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                              validator: (v) => v == null || v.length < 6 ? 'Min. 6 caractères' : null,
                              delay: 300.ms,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mot de passe oublié
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 32),
                          ),
                          child: Text(
                            'Mot de passe oublié ?',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ).animate(delay: 350.ms).fadeIn(),

                      const SizedBox(height: 24),

                      // Bouton connexion
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Se connecter',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 24),

                      // Séparateur
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'ou',
                              style: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                        ],
                      ).animate(delay: 450.ms).fadeIn(),

                      const SizedBox(height: 24),

                      // ✅ BOUTON GOOGLE AVEC VRAI LOGO (depuis assets)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: isLoading ? null : _handleGoogleLogin,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.border),
                            backgroundColor: AppColors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ✅ VRAI LOGO GOOGLE depuis assets
                              Image.asset(
                                'assets/images/logo/google_logo.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isLoading ? 'Connexion...' : 'Continuer avec Google',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 32),

                      // Lien inscription
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nouveau ici ? ',
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                'Créer un compte',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).animate(delay: 600.ms).fadeIn(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required Duration delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.poppins(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
          ),
        ),
      ],
    ).animate(delay: delay).fadeIn().slideY(begin: 0.1, end: 0);
  }
}