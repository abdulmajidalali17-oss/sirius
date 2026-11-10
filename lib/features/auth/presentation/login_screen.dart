import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_providers.dart';
import 'create_account_screen.dart';

// Brand palette
const Color _brandPurple = Color(0xFF7C5CFF);
const Color _brandPurpleSoft = Color(0xFF9C86FF);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Validation

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();

    if (email.isEmpty) return 'Enter your email';

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) return 'Enter your password';

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Firebase error handling

  String _getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : _brandPurple,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Sign in

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      _showMessage('Welcome back to Sirius!');
    } on FirebaseAuthException catch (error) {
      _showMessage(_getFirebaseErrorMessage(error), isError: true);
    } catch (_) {
      _showMessage('An unexpected error occurred.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // Forgot password

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email first.', isError: true);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _showMessage('Password reset email sent.');
    } on FirebaseAuthException catch (error) {
      _showMessage(_getFirebaseErrorMessage(error), isError: true);
    }
  }

  // Navigate to Create Account

  void _openCreateAccount() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
    );
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 960;

            const horizontalPadding = 24.0;
            const verticalPadding = 32.0;

            final contentWidth = isWide ? 1160.0 : 480.0;

            final minContentHeight =
                (constraints.maxHeight - verticalPadding * 2).clamp(
                  0.0,
                  double.infinity,
                );

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minContentHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: isWide
                        ? _buildWideLayout(theme)
                        : _buildNarrowLayout(theme),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 11,
          child: Padding(
            padding: const EdgeInsets.only(right: 56),
            child: _BrandPanel(theme: theme),
          ),
        ),
        Expanded(flex: 9, child: _buildFormCard(theme)),
      ],
    );
  }

  Widget _buildNarrowLayout(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _SiriusMark(size: 36),
            const SizedBox(width: 10),
            Text(
              'Sirius',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _buildFormCard(theme),
      ],
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome Back',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Continue your journey of turning ideas into knowledge.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            _buildEmailField(theme),
            const SizedBox(height: 16),
            _buildPasswordField(theme),
            const SizedBox(height: 8),
            _buildRememberRow(theme),
            const SizedBox(height: 20),
            _buildSignInButton(theme),
            const SizedBox(height: 24),
            _buildOrDivider(theme),
            const SizedBox(height: 24),
            _buildGoogleButton(theme),
            const SizedBox(height: 20),
            _buildCreateAccountLink(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      validator: _validateEmail,
      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
      style: TextStyle(color: theme.colorScheme.onSurface),
      cursorColor: _brandPurple,
      decoration: _inputDecoration(
        theme: theme,
        label: 'Email',
        hint: 'you@example.com',
        prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),
      ),
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      validator: _validatePassword,
      onFieldSubmitted: (_) => _handleSubmit(),
      style: TextStyle(color: theme.colorScheme.onSurface),
      cursorColor: _brandPurple,
      decoration: _inputDecoration(
        theme: theme,
        label: 'Password',
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          tooltip: _obscurePassword ? 'Show password' : 'Hide password',
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRememberRow(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _rememberMe = !_rememberMe;
              });
            },
            child: Text('Remember me', style: theme.textTheme.bodyMedium),
          ),
        ),
        TextButton(
          onPressed: _handleForgotPassword,
          style: TextButton.styleFrom(
            foregroundColor: _brandPurple,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }

  Widget _buildSignInButton(ThemeData theme) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
        style: FilledButton.styleFrom(
          backgroundColor: _brandPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _brandPurple.withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Text('Sign In'),
      ),
    );
  }

  Widget _buildOrDivider(ThemeData theme) {
    final lineColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);

    return Row(
      children: [
        Expanded(child: Divider(color: lineColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: lineColor, thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton(ThemeData theme) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () {
          _showMessage('Google Sign-In will be implemented later.');
        },
        icon: Icon(
          Icons.g_mobiledata,
          size: 28,
          color: theme.colorScheme.onSurface,
        ),
        label: const Text('Continue with Google'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to Sirius?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: _openCreateAccount,
          style: TextButton.styleFrom(
            foregroundColor: _brandPurple,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Create Account'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required ThemeData theme,
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final side = BorderSide(
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
    );

    final radius = BorderRadius.circular(14);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.35,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      floatingLabelStyle: const TextStyle(color: _brandPurple),
      border: OutlineInputBorder(borderRadius: radius, borderSide: side),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: side),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: _brandPurple, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
    );
  }
}

// Brand panel

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _SiriusMark(size: 44),
            const SizedBox(width: 14),
            Text(
              'Sirius',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          'Turn ideas into\ninteractive knowledge maps.',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Organize, connect and explore your thoughts with AI.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        const SizedBox(
          height: 300,
          child: _KnowledgeNetwork(accent: _brandPurple),
        ),
      ],
    );
  }
}

class _SiriusMark extends StatelessWidget {
  const _SiriusMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_brandPurpleSoft, _brandPurple],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: _brandPurple.withValues(alpha: 0.45),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}

// Knowledge network illustration

class _KnowledgeNetwork extends StatelessWidget {
  const _KnowledgeNetwork({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _KnowledgeNetworkPainter(accent: accent),
      size: Size.infinite,
    );
  }
}

class _KnowledgeNetworkPainter extends CustomPainter {
  _KnowledgeNetworkPainter({required this.accent});

  final Color accent;

  static const List<Offset> _nodes = [
    Offset(0.15, 0.30),
    Offset(0.35, 0.18),
    Offset(0.58, 0.32),
    Offset(0.82, 0.22),
    Offset(0.72, 0.55),
    Offset(0.48, 0.60),
    Offset(0.22, 0.68),
    Offset(0.42, 0.82),
    Offset(0.68, 0.80),
    Offset(0.88, 0.70),
  ];

  static const List<List<int>> _edges = [
    [0, 1],
    [1, 2],
    [2, 3],
    [2, 5],
    [3, 4],
    [4, 5],
    [5, 6],
    [5, 7],
    [7, 8],
    [8, 9],
    [4, 8],
    [6, 7],
    [0, 6],
    [1, 5],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = accent.withValues(alpha: 0.28)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (final edge in _edges) {
      final a = _nodes[edge[0]];
      final b = _nodes[edge[1]];

      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        edgePaint,
      );
    }

    for (var i = 0; i < _nodes.length; i++) {
      final node = _nodes[i];

      final center = Offset(node.dx * size.width, node.dy * size.height);

      final isKey = i == 2 || i == 5;
      final radius = isKey ? 8.0 : 5.0;

      canvas.drawCircle(
        center,
        radius * 2.6,
        Paint()
          ..color = accent.withValues(alpha: isKey ? 0.22 : 0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawCircle(
        center,
        radius,
        Paint()..color = isKey ? accent : accent.withValues(alpha: 0.85),
      );

      canvas.drawCircle(
        center,
        radius * 0.4,
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _KnowledgeNetworkPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
