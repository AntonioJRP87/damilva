import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/features/category/data/datasources/category_data_source.dart';
import 'package:damilva/features/category/data/models/category_listing_remote_entity.dart';
import 'package:damilva/features/category/data/repositories/category_repository_impl.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryDataSource implements CategoryDataSourceContract {
  _FakeCategoryDataSource({this.response, this.error});

  final CategoryListingRemoteEntity? response;
  final CustomErrors? error;

  @override
  Future<CategoryListingRemoteEntity> getCategoryListing({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) async {
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<CategoryListingRemoteEntity> getSearchListing({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) async {
    if (error != null) throw error!;
    return response!;
  }
}

const _json = {
  'total': 1,
  'productos': [
    {
      'id': '1',
      'nombre': 'Vestido midi de lunares',
      'precio': 39.9,
      'precioAnterior': 49.9,
      'etiqueta': 'oferta',
      'agotado': false,
      'imagen': 'img.jpg',
    },
  ],
  'filtrosDisponibles': {
    'tallas': ['S', 'M', 'L'],
    'colores': ['Rojo', 'Negro'],
    'precioMin': 10,
    'precioMax': 100,
  },
};

void main() {
  test(
    'maps a successful category listing response to a Result.success',
    () async {
      final repository = CategoryRepositoryImpl(
        _FakeCategoryDataSource(
          response: CategoryListingRemoteEntity.fromJson(_json),
        ),
      );

      final result = await repository.getCategoryListing(
        categoryId: 'vestidos-y-monos',
        onlyInStock: false,
        sort: CategorySortOption.newestFirst,
        page: 1,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data!.total, 1);
      expect(result.data!.products.single.name, 'Vestido midi de lunares');
      expect(result.data!.filters.sizes, ['S', 'M', 'L']);
    },
  );

  test(
    'maps a successful search listing response to a Result.success',
    () async {
      final repository = CategoryRepositoryImpl(
        _FakeCategoryDataSource(
          response: CategoryListingRemoteEntity.fromJson(_json),
        ),
      );

      final result = await repository.getSearchListing(
        query: 'vestido rojo',
        onlyInStock: false,
        sort: CategorySortOption.newestFirst,
        page: 1,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data!.total, 1);
    },
  );

  test('maps a thrown CustomErrors to the matching AppError', () async {
    final repository = CategoryRepositoryImpl(
      _FakeCategoryDataSource(error: const CustomErrors.errorServer()),
    );

    final result = await repository.getCategoryListing(
      categoryId: 'vestidos-y-monos',
      onlyInStock: false,
      sort: CategorySortOption.newestFirst,
      page: 1,
    );

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.errorServer());
  });
}
