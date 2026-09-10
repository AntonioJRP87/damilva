import 'package:damilva/core/l10n/app_localizations.dart';
import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/features/widgets/product_cards/custom_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpCard(WidgetTester tester, Widget card) {
  return tester.pumpWidget(
    MaterialApp(
      theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SizedBox(width: 200, child: card)),
    ),
  );
}

void main() {
  testWidgets('shows the "new" badge label', (tester) async {
    await _pumpCard(
      tester,
      const CustomProductCard(
        imageUrl: 'https://example.com/image.jpg',
        name: 'Camisa de lino',
        price: '39,90 €',
        badge: ProductCardBadge.newIn,
      ),
    );

    expect(find.text('NUEVO'), findsOneWidget);
  });

  testWidgets('shows the "offer" badge label', (tester) async {
    await _pumpCard(
      tester,
      const CustomProductCard(
        imageUrl: 'https://example.com/image.jpg',
        name: 'Camisa de lino',
        price: '39,90 €',
        badge: ProductCardBadge.offer,
      ),
    );

    expect(find.text('OFERTA'), findsOneWidget);
  });

  testWidgets('shows a centered sold-out stamp and no corner badge', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      const CustomProductCard(
        imageUrl: 'https://example.com/image.jpg',
        name: 'Camisa de lino',
        price: '39,90 €',
        badge: ProductCardBadge.soldOut,
      ),
    );

    expect(find.text('AGOTADO'), findsOneWidget);
    expect(find.text('NUEVO'), findsNothing);
    expect(find.text('OFERTA'), findsNothing);
  });

  testWidgets('truncates the name to two lines', (tester) async {
    await _pumpCard(
      tester,
      const CustomProductCard(
        imageUrl: 'https://example.com/image.jpg',
        name: 'Camisa de lino',
        price: '39,90 €',
      ),
    );

    final text = tester.widget<Text>(find.text('Camisa de lino'));
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
  });

  testWidgets('shows the previous price struck through', (tester) async {
    await _pumpCard(
      tester,
      const CustomProductCard(
        imageUrl: 'https://example.com/image.jpg',
        name: 'Camisa de lino',
        price: '29,90 €',
        previousPrice: '39,90 €',
      ),
    );

    final text = tester.widget<Text>(find.text('39,90 €'));
    expect(text.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('tapping the card triggers onTap', (tester) async {
    var tapped = false;
    await _pumpCard(
      tester,
      CustomProductCard(
        imageUrl: 'https://example.com/image.jpg',
        name: 'Camisa de lino',
        price: '39,90 €',
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byType(CustomProductCard));
    expect(tapped, isTrue);
  });

  testWidgets(
    'tapping the wishlist heart triggers onWishlistToggle but not onTap',
    (tester) async {
      var tapped = false;
      var wishlistToggled = false;
      await _pumpCard(
        tester,
        CustomProductCard(
          imageUrl: 'https://example.com/image.jpg',
          name: 'Camisa de lino',
          price: '39,90 €',
          onTap: () => tapped = true,
          onWishlistToggle: () => wishlistToggled = true,
        ),
      );

      await tester.tap(find.bySemanticsLabel('Añadir a la lista de deseos'));

      expect(wishlistToggled, isTrue);
      expect(tapped, isFalse);
    },
  );
}
