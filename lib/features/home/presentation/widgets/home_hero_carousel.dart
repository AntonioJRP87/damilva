import 'dart:async';

import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/home/domain/entities/carousel_slide.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeHeroCarousel extends StatefulWidget {
  const HomeHeroCarousel({super.key, required this.slides});

  final List<CarouselSlide> slides;

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel> {
  late final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _scheduleAutoplay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleAutoplay() {
    _timer?.cancel();
    if (widget.slides.length <= 1) return;
    _timer = Timer.periodic(
      Duration(seconds: AppSizes.homeHeroAutoplaySeconds.toInt()),
      (_) {
        if (_paused || !mounted) return;
        _goTo((_currentPage + 1) % widget.slides.length);
      },
    );
  }

  void _goTo(int page) {
    _controller.animateTo(
      page * (_controller.position.viewportDimension),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _setPaused(bool paused) {
    if (_paused == paused) return;
    setState(() => _paused = paused);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    final colors = context.damilvaColors;

    return MouseRegion(
      onEnter: (_) => _setPaused(true),
      onExit: (_) => _setPaused(false),
      child: Focus(
        onFocusChange: _setPaused,
        child: AspectRatio(
          aspectRatio: context.homeHeroAspectRatio,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: widget.slides.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  return _HeroSlide(slide: widget.slides[index]);
                },
              ),
              if (widget.slides.length > 1) ...[
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _HeroArrow(
                      icon: LucideIcons.chevronLeft,
                      onPressed: () => _goTo(
                        (_currentPage - 1 + widget.slides.length) %
                            widget.slides.length,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _HeroArrow(
                      icon: LucideIcons.chevronRight,
                      onPressed: () =>
                          _goTo((_currentPage + 1) % widget.slides.length),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.slides.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.homeCarouselDotSpacing / 2,
                        ),
                        child: GestureDetector(
                          onTap: () => _goTo(index),
                          child: Container(
                            width: AppSizes.homeCarouselDotSize,
                            height: AppSizes.homeCarouselDotSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentPage
                                  ? colors.white
                                  : colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroArrow extends StatelessWidget {
  const _HeroArrow({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return Material(
      color: colors.white.withValues(alpha: 0.85),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: colors.ink),
        ),
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.slide});

  final CarouselSlide slide;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: colors.surface,
          child: Image.network(
            slide.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ),
        Positioned(
          left: context.responsiveMargin,
          bottom: 56,
          right: context.responsiveMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slide.kicker.toUpperCase(),
                style: typography.text12w800caps.copyWith(color: colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                slide.title,
                style:
                    (context.isMobile
                            ? typography.text32w800
                            : typography.text64w800)
                        .copyWith(color: colors.white),
              ),
              const SizedBox(height: 16),
              _HeroCta(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCta extends StatelessWidget {
  const _HeroCta();

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.primary),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
        child: Text(
          context.localizations.home_hero_cta.toUpperCase(),
          style: typography.text14w800.copyWith(color: colors.white),
        ),
      ),
    );
  }
}
