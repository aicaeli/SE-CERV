import 'dart:async';
import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final _pageController = PageController();
  final _slides = const [
    _SlideData(
      title: 'Real-time GPS Tagging',
      description: 'Attach accurate GPS locations to your reports for faster response.',
      assetPath: 'assets/images/location.png',
    ),
    _SlideData(
      title: 'Verified Reporting',
      description: 'Submit dependable, community-backed incident reports in seconds.',
      assetPath: 'assets/images/verify.png',
    ),
    _SlideData(
      title: 'Instant Notifications',
      description: 'Stay informed with immediate alerts for emergencies around you.',
      assetPath: 'assets/images/community.png',
    ),
  ];

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalSpacing = size.height < 700 ? 16.0 : 24.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 241, 239, 244),
              Color(0xFF5C4DE8),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = size.width < 400 ? 24.0 : 40.0;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalSpacing,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FadeInUp(
                        from: 24,
                        duration: const Duration(milliseconds: 900),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _slides.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final slide = _slides[index];
                            return _SlideCard(data: slide);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                    _DotsIndicator(
                      count: _slides.length,
                      activeIndex: _currentPage,
                    ),
                    SizedBox(height: verticalSpacing * 1.25),
                    _PrimaryButton(
                      label: 'Log In',
                      filled: true,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                    ),
                    SizedBox(height: verticalSpacing / 1.5),
                    _PrimaryButton(
                      label: 'Register',
                      filled: false,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                    ),
                    SizedBox(height: verticalSpacing),
                    const _Footer(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  const _SlideCard({required this.data});

  final _SlideData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final imageSize = (availableWidth * 0.55).clamp(120.0, 220.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: imageSize,
              width: math.min(imageSize * 1.2, availableWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Image.asset(
                  data.assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.place,
                      size: imageSize * 0.7,
                      color: Colors.white.withValues(alpha: 0.8),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 14 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF5C4DE8) : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF5C4DE8);
    return AnimatedSlide(
      duration: const Duration(milliseconds: 150),
      offset: Offset(0, _pressed ? 0.05 : 0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          decoration: BoxDecoration(
            color: widget.filled ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: widget.filled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: _pressed ? 4 : 12,
                      offset: const Offset(0, 6),
                    )
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: widget.filled ? primaryColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 13,
      color: Colors.white,
      decoration: TextDecoration.underline,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Text('Terms of Service', style: textStyle),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {},
              child: Text('Privacy Policy', style: textStyle),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '© 2025 CERV, All Rights Reserved.',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.title,
    required this.description,
    required this.assetPath,
  });

  final String title;
  final String description;
  final String assetPath;
}

