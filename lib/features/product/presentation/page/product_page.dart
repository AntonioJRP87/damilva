import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/presentation/bloc/product_bloc.dart';
import 'package:damilva/features/product/presentation/bloc/product_event.dart';
import 'package:damilva/features/product/presentation/bloc/product_state.dart';
import 'package:damilva/features/product/presentation/widgets/product_add_to_cart_section.dart';
import 'package:damilva/features/product/presentation/widgets/product_color_selector.dart';
import 'package:damilva/features/product/presentation/widgets/product_gallery.dart';
import 'package:damilva/features/product/presentation/widgets/product_info_accordion.dart';
import 'package:damilva/features/product/presentation/widgets/product_loading_view.dart';
import 'package:damilva/features/product/presentation/widgets/product_price_block.dart';
import 'package:damilva/features/product/presentation/widgets/product_related_section.dart';
import 'package:damilva/features/product/presentation/widgets/product_shipping_note.dart';
import 'package:damilva/features/product/presentation/widgets/product_size_selector.dart';
import 'package:damilva/features/product/presentation/widgets/product_unavailable_view.dart';
import 'package:damilva/shared/widgets/errors/custom_full_screen_error.dart';
import 'package:damilva/shared/widgets/mixins/errors_message_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          presentationDi<ProductBloc>()..add(ProductEvent.started(productId)),
      child: const SafeArea(child: _ProductView()),
    );
  }
}

class _ProductView extends StatelessWidget with ErrorsMessageMixin {
  const _ProductView();

  void _showSnackbar(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    context.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: colors.ink,
        content: Text(
          message,
          style: typography.text14w400.copyWith(color: colors.white),
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: colors.primary,
                onPressed: onAction!,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;

    return BlocConsumer<ProductBloc, ProductState>(
      listenWhen: (previous, current) =>
          previous.addToCartRequestId != current.addToCartRequestId,
      listener: (context, state) {
        switch (state.addToCartStatus) {
          case AddToCartStatus.success:
            _showSnackbar(
              context,
              message: localizations.product_added_to_cart_message,
              actionLabel: localizations.product_view_cart,
              onAction: () => context.go('/carrito'),
            );
          case AddToCartStatus.insufficientStock:
            _showSnackbar(
              context,
              message: localizations.product_quantity_adjusted,
            );
          case AddToCartStatus.error:
            _showSnackbar(
              context,
              message: errorText(context, state.addToCartError!),
              actionLabel: localizations.retry,
              onAction: () => context.read<ProductBloc>().add(
                const ProductEvent.addToCartRequested(),
              ),
            );
          case AddToCartStatus.idle:
          case AddToCartStatus.submitting:
            break;
        }
      },
      builder: (context, state) {
        return switch (state.status) {
          ProductStatus.initial ||
          ProductStatus.loading => const ProductLoadingView(),
          ProductStatus.unavailable => ProductUnavailableView(
            onGoToCategory: () =>
                context.canPop() ? context.pop() : context.go('/'),
          ),
          ProductStatus.error => CustomFullScreenError(
            error: state.error!,
            onRetry: () =>
                context.read<ProductBloc>().add(const ProductEvent.retried()),
            onGoHome: () => context.go('/'),
          ),
          ProductStatus.success => _ProductContent(state: state),
        };
      },
    );
  }
}

class _ProductContent extends StatelessWidget {
  const _ProductContent({required this.state});

  final ProductState state;

  @override
  Widget build(BuildContext context) {
    final ProductDetail product = state.product!;
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;
    final margin = context.responsiveMargin;
    final isDesktop = context.isDesktop;
    final bloc = context.read<ProductBloc>();

    final gallery = ProductGallery(
      images: product.images,
      productName: product.name,
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: (isDesktop ? typography.text40w800 : typography.text26w800)
              .copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSizes.productContentSpacing),
        ProductPriceBlock(
          price: product.price,
          previousPrice: product.previousPrice,
        ),
        const SizedBox(height: AppSizes.productSectionSpacing),
        ProductColorSelector(
          colors: product.colors,
          colorHexOf: product.colorHexFor,
          selectedColor: state.selectedColor,
          onColorSelected: (color) =>
              bloc.add(ProductEvent.colorSelected(color)),
        ),
        const SizedBox(height: AppSizes.productSectionSpacing),
        ProductSizeSelector(
          product: product,
          selectedColor: state.selectedColor,
          selectedSize: state.selectedSize,
          onSizeSelected: (size) => bloc.add(ProductEvent.sizeSelected(size)),
        ),
        const SizedBox(height: AppSizes.productSelectorSpacing),
        TextButton(
          onPressed: null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
          ),
          child: Text(
            localizations.product_size_guide_link,
            style: typography.text13w400,
          ),
        ),
        const SizedBox(height: AppSizes.productSectionSpacing),
        ProductAddToCartSection(
          product: product,
          selectedSize: state.selectedSize,
          selectedVariant: state.selectedVariant,
          quantity: state.quantity,
          isSubmitting: state.addToCartStatus == AddToCartStatus.submitting,
          onIncrement: () => bloc.add(const ProductEvent.quantityIncremented()),
          onDecrement: () => bloc.add(const ProductEvent.quantityDecremented()),
          onAddToCart: () => bloc.add(const ProductEvent.addToCartRequested()),
        ),
        const SizedBox(height: AppSizes.productSectionSpacing),
        const ProductShippingNote(),
        const SizedBox(height: AppSizes.productSectionSpacing),
        ProductInfoAccordion(
          description: product.description,
          composition: product.composition,
          returnsInfo: product.returnsInfo,
        ),
      ],
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: margin,
        vertical: AppSizes.productSectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: gallery),
                    const SizedBox(width: AppSizes.productColumnSpacing),
                    Expanded(child: info),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    gallery,
                    const SizedBox(height: AppSizes.productSectionSpacing),
                    info,
                  ],
                ),
          const SizedBox(height: AppSizes.productSectionSpacing),
          ProductRelatedSection(related: product.related),
        ],
      ),
    );
  }
}
