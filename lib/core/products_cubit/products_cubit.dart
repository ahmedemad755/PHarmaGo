import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

extension ProductSearch on AddProductIntety {
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        code.toLowerCase().contains(lowerQuery);
  }

  bool matchesCategory(String selectedCategory) {
    return category == selectedCategory;
  }
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  int productsLength = 0;

  List<AddProductIntety> _allProducts = [];

  String _currentSearchQuery = '';
  String _selectedCategory = 'الأدوية';
  String _selectedSort = 'relevance';
  num _minDiscountValue = 0;

  List<AddProductIntety> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  String get selectedSort => _selectedSort;
  num get minDiscountValue => _minDiscountValue;

  // ميثود التصفية لضمان عدم تكرار الكود في الواجهة الرئيسية
  List<AddProductIntety> _getUniqueProducts(
    List<AddProductIntety> allProducts,
  ) {
    final Map<String, AddProductIntety> uniqueMap = {};
    for (var item in allProducts) {
      if (!uniqueMap.containsKey(item.code)) {
        uniqueMap[item.code] = item;
      }
    }
    return uniqueMap.values.toList();
  }

  Future<void> getProducts() async {
    emit(ProductsLoading());
    final Either<Faliur, List<AddProductIntety>> result = await productsRepo
        .getProducts();

    result.fold((failure) => emit(ProductsFailure(failure.message)), (
      products,
    ) {
      // تصفية المنتجات قبل تخزينها لعرضها في الهوم
      _allProducts = _getUniqueProducts(products);
      _applyFilters();
    });
  }

  Future<void> fetchBestSelling({int topN = 10}) async {
    emit(ProductsLoading());
    final Either<Faliur, List<AddProductIntety>> result = await productsRepo
        .getBestSellingProducts(topN: topN);

    result.fold((failure) => emit(ProductsFailure(failure.message)), (
      products,
    ) {
      _allProducts = _getUniqueProducts(products);
      _applyFilters();
    });
  }

  void searchProducts(String query) {
    final newQuery = query.trim();
    if (_currentSearchQuery == newQuery) return;
    _currentSearchQuery = newQuery;
    _applyFilters();
  }

  void applyCategoryFilter(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _applyFilters();
  }

  void applySortFilter(String sortOption) {
    if (_selectedSort == sortOption) return;
    _selectedSort = sortOption;
    _applyFilters();
  }

  void applyDiscountFilter(int minDiscount) {
    if (_minDiscountValue == minDiscount) return;
    _minDiscountValue = minDiscount;
    _applyFilters();
  }

  void resetFilters() {
    _currentSearchQuery = '';
    _selectedCategory = 'الأدوية';
    _selectedSort = 'relevance';
    _minDiscountValue = 0;
    _applyFilters();
  }

  void _applyFilters() {
    if (_allProducts.isEmpty) {
      emit(ProductsSuccess(const []));
      return;
    }

    Iterable<AddProductIntety> currentFilteredList = _allProducts;

    currentFilteredList = currentFilteredList.where(
      (product) => product.matchesCategory(_selectedCategory),
    );

    if (_currentSearchQuery.isNotEmpty) {
      currentFilteredList = currentFilteredList.where(
        (product) => product.matchesSearch(_currentSearchQuery),
      );
    }

    if (_minDiscountValue > 0) {
      currentFilteredList = currentFilteredList.where((product) {
        return product.discountPercentage >= _minDiscountValue;
      });
    }

    List<AddProductIntety> sortedList = currentFilteredList.toList();

    switch (_selectedSort) {
      case 'price_asc':
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'relevance':
      default:
        break;
    }

    emit(ProductsSuccess(sortedList));
  }
}
