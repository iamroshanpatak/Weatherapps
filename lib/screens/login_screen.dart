import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  // Animation controllers
  late AnimationController _sunController;
  late AnimationController _cloudController;
  late AnimationController _rainController;
  late AnimationController _fadeController;

  // Animations
  late Animation<double> _sunAnimation;
  late Animation<double> _cloudAnimation;
  late Animation<double> _rainAnimation;
  late Animation<double> _rainTranslationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _sunController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _cloudController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _rainController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize animations
    _sunAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _sunController,
      curve: Curves.linear,
    ));

    _cloudAnimation = Tween<double>(
      begin: -100,
      end: 400,
    ).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeInOut,
    ));

    _rainAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rainController,
      curve: Curves.easeInOut,
    ));

    _rainTranslationAnimation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(CurvedAnimation(
      parent: _rainController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _sunController.repeat();
    _cloudController.repeat();
    _rainController.repeat();
    _fadeController.repeat(reverse: true);

    // Add focus listeners
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _sunController.dispose();
    _cloudController.dispose();
    _rainController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login() async {
    // Email validation
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    // Check if email is empty
    if (email.isEmpty) {
      setState(() {
        // Show error through auth provider
        Provider.of<AuthProvider>(context, listen: false).setError('Email is required');
      });
      return;
    }
    
    // Check if email is a valid Gmail format
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).setError('Please enter a valid Gmail address');
      });
      return;
    }
    
    // Check if password is empty
    if (password.isEmpty) {
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).setError('Password is required');
      });
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signIn(email, password);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
              ? [
                  const Color(0xFF1E3C72),
                  const Color(0xFF2A5298),
                  const Color(0xFF4A90E2),
                  const Color(0xFF87CEEB),
                ]
              : [
                  const Color(0xFF667eea),
                  const Color(0xFF764ba2),
                  const Color(0xFFf093fb),
                  const Color(0xFFf5576c),
                ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            Positioned(
              top: 50,
              left: 20,
              child: AnimatedBuilder(
                animation: _sunAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _sunAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/sun.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Positioned(
              top: 100,
              right: 30,
              child: AnimatedBuilder(
                animation: _cloudAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_cloudAnimation.value, 0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/cloudy.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: 200,
              left: 50,
              child: AnimatedBuilder(
                animation: Listenable.merge([_rainAnimation, _rainTranslationAnimation]),
                builder: (context, child) {
                  return Opacity(
                    opacity: _rainAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _rainTranslationAnimation.value),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icons/rain.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App title with shadow
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Weather icon without animation
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icons/cloudy (2).png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'WEATHER',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Your Personal Weather Companion',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Login form with styled boxes
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Email input field
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: (_isEmailFocused || _emailController.text.isNotEmpty) ? null : 'Email',
                                      labelStyle: TextStyle(color: _isEmailFocused ? Colors.blue : Colors.black54),
                                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    focusNode: _emailFocusNode,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Password input field
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: (_isPasswordFocused || _passwordController.text.isNotEmpty) ? null : 'Password',
                                      labelStyle: TextStyle(color: _isPasswordFocused ? Colors.blue : Colors.black54),
                                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                    ),
                                    obscureText: true,
                                    focusNode: _passwordFocusNode,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Login button
                                if (authProvider.isLoading)
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                else
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.blue, Colors.blueAccent],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                if (authProvider.error != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      authProvider.error!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                const SizedBox(height: 20),

                                // Sign up link
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, '/signup');
                                  },
                                  child: const Text(
                                    'Don\'t have an account? Sign up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
} 