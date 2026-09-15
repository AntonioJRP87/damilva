import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';

class ProductGallery extends StatefulWidget {
  const ProductGallery({
    super.key,
    required this.images,
    required this.productName,
  });

  final List<String> images;
  final String productName;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    setState(() => _index = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _openZoom() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (_) =>
          _ProductZoomView(images: widget.images, initialIndex: _index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: AppSizes.productGalleryAspectRatio,
        child: ColoredBox(color: colors.surface),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: AppSizes.productGalleryAspectRatio,
          child: GestureDetector(
            onTap: _openZoom,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _index = index),
              itemBuilder: (context, index) => ColoredBox(
                color: colors.surface,
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.contain,
                  semanticLabel: widget.productName,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: AppSizes.productGallerySpacing),
          context.isDesktop
              ? _ThumbnailRow(
                  images: widget.images,
                  selectedIndex: _index,
                  onSelected: _goTo,
                )
              : _DashIndicator(
                  count: widget.images.length,
                  selectedIndex: _index,
                ),
        ],
      ],
    );
  }
}

class _ThumbnailRow extends StatelessWidget {
  const _ThumbnailRow({
    required this.images,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return Row(
      children: [
        for (var i = 0; i < images.length; i++)
          Padding(
            padding: EdgeInsets.only(
              right: i == images.length - 1
                  ? 0
                  : AppSizes.productGallerySpacing,
            ),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: Container(
                width: AppSizes.productThumbnailSize,
                height: AppSizes.productThumbnailSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: i == selectedIndex
                        ? colors.primary
                        : Colors.transparent,
                    width: AppSizes.productThumbnailBorderWidth,
                  ),
                ),
                child: ColoredBox(
                  color: colors.surface,
                  child: Image.network(
                    images[i],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DashIndicator extends StatelessWidget {
  const _DashIndicator({required this.count, required this.selectedIndex});

  final int count;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.homeCarouselDotSpacing / 2,
            ),
            child: Container(
              width: AppSizes.homeCarouselDotSize * 2,
              height: AppSizes.homeCarouselDotSize / 2,
              color: i == selectedIndex
                  ? colors.ink
                  : colors.ink.withValues(alpha: 0.25),
            ),
          ),
      ],
    );
  }
}

class _ProductZoomView extends StatelessWidget {
  const _ProductZoomView({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: images.length,
            itemBuilder: (context, index) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: CustomIcon(AppIcon.x, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
