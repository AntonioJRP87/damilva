import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:damilva/features/home/presentation/bloc/home_bloc.dart';
import 'package:damilva/features/home/presentation/bloc/home_event.dart';
import 'package:damilva/features/home/presentation/bloc/home_state.dart';
import 'package:damilva/features/home/presentation/widgets/home_featured_categories_section.dart';
import 'package:damilva/features/home/presentation/widgets/home_hero_carousel.dart';
import 'package:damilva/features/home/presentation/widgets/home_loading_view.dart';
import 'package:damilva/features/home/presentation/widgets/home_new_arrivals_section.dart';
import 'package:damilva/features/home/presentation/widgets/home_top_banner.dart';
import 'package:damilva/features/home/presentation/widgets/home_trust_bar.dart';
import 'package:damilva/shared/widgets/errors/custom_full_screen_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => presentationDi<HomeBloc>()..add(const HomeEvent.started()),
      child: const Scaffold(body: SafeArea(child: _HomeView())),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return switch (state.status) {
          HomeStatus.initial || HomeStatus.loading => const HomeLoadingView(),
          HomeStatus.error => CustomFullScreenError(
            error: state.error!,
            onRetry: () =>
                context.read<HomeBloc>().add(const HomeEvent.refreshed()),
          ),
          HomeStatus.success => _HomeContentView(content: state.content!),
        };
      },
    );
  }
}

class _HomeContentView extends StatelessWidget {
  const _HomeContentView({required this.content});

  final HomeContent content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeTopBanner(freeShippingThreshold: content.freeShippingThreshold),
          HomeHeroCarousel(slides: content.carousel),
          const SizedBox(height: AppSizes.homeSectionSpacing),
          HomeNewArrivalsSection(products: content.newArrivals),
          const SizedBox(height: AppSizes.homeSectionSpacing),
          HomeFeaturedCategoriesSection(categories: content.featuredCategories),
          const SizedBox(height: AppSizes.homeSectionSpacing),
          const HomeTrustBar(),
        ],
      ),
    );
  }
}
