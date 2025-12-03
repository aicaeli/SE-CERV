import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _logoPulseController; // NEW

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  // NEW – background + content slide
  late final Animation<Offset> _slideUpAnimation;

  // NEW – button slight delay
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    // Main fade + scale controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Logo breathing/pulse controller
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true); // loop

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Fade & scale
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _scaleAnimation = Tween<double>(begin: 0.93, end: 1.0).animate(curved);

    // NEW: Slide animation (upward)
    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // NEW: button fade (delayed look)
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _logoPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPadding = media.size.width < 400 ? 20.0 : 32.0;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 241, 239, 244),
                Color(0xFF5C4DE8),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 32,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SlideTransition(
                      position: _slideUpAnimation, // NEW
                      child: Column(
                        children: [
                          ScaleTransition(
                            scale: _logoPulseController, // NEW glow pulse
                            child: _LogoGlow(screenWidth: media.size.width),
                          ),
                          const SizedBox(height: 32),
                          _TitleBlock(),
                          const SizedBox(height: 48),

                          /// BUTTON with delay fade
                          FadeTransition(
                            opacity: _buttonFade, // NEW
                            child: _GetStartedButton(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/get_started');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoGlow extends StatelessWidget {
  const _LogoGlow({required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final logoWidth = (screenWidth * 0.45).clamp(120.0, 260.0);
    final glowSize = logoWidth * 1.25;

    return SizedBox(
      width: glowSize,
      height: glowSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: glowSize,
            height: glowSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.55),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          Image.asset(
            'lib/cerv_logo.png',
            width: logoWidth,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'CERV',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Citizen Emergency Reporting & Verification',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFF8F4FF).withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF5C4DE8),
          elevation: 10,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: const Color(0xFF5C4DE8).withValues(alpha: 0.25),
        ),
        child: const Text(
          'GET STARTED',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
