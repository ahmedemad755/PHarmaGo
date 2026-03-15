// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:e_commerce/core/enteties/product_enteti.dart';
// import 'package:e_commerce/core/errors/faliur.dart';
// import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
// import 'package:meta/meta.dart';

// part 'products_state.dart';

// extension ProductSearch on AddProductIntety {
//   bool matchesSearch(String query) {
//     if (query.isEmpty) return true;
//     final lowerQuery = query.toLowerCase();
//     return name.toLowerCase().contains(lowerQuery) ||
//         code.toLowerCase().contains(lowerQuery);
//   }

//   bool matchesCategory(String selectedCategory) {
//     return category == selectedCategory;
//   }
// }

// class ProductsCubit extends Cubit<ProductsState> {
//   ProductsCubit(this.productsRepo) : super(ProductsInitial());

//   final ProductsRepo productsRepo;
//   int get productsLength => _allProducts.length;
//   List<AddProductIntety> _allProducts = [];

//   String _currentSearchQuery = '';
//   String _selectedCategory = 'الأدوية';
//   String _selectedSort = 'relevance';
//   num _minDiscountValue = 0;

//   List<AddProductIntety> get allProducts => _allProducts;
//   String get selectedCategory => _selectedCategory;
//   String get selectedSort => _selectedSort;
//   num get minDiscountValue => _minDiscountValue;

//   // 🔹 ميثود لمراقبة الأكثر مبيعاً (تحديث تلقائي للرقم)
//   void fetchBestSelling({int topN = 10}) {
//     emit(ProductsLoading());
//     productsRepo.fetchBestSellingProductsStream(topN: topN).listen((result) {
//       result.fold(
//         (failure) => emit(ProductsFailure(failure.message)),
//         (products) {
//           _allProducts = _getUniqueProducts(products);
//           _applyFilters();
//         },
//       );
//     });
//   }

//   // 🔹 ميثود جلب كل المنتجات (Future)
//   Future<void> getProducts() async {
//     emit(ProductsLoading());
//     final result = await productsRepo.getProducts();

//     result.fold(
//       (failure) => emit(ProductsFailure(failure.message)),
//       (products) {
//         _allProducts = _getUniqueProducts(products);
//         _applyFilters();
//       },
//     );
//   }

//   List<AddProductIntety> _getUniqueProducts(List<AddProductIntety> allProducts) {
//     final Map<String, AddProductIntety> uniqueMap = {};
//     for (var item in allProducts) {
//       if (!uniqueMap.containsKey(item.code)) {
//         uniqueMap[item.code] = item;
//       }
//     }
//     return uniqueMap.values.toList();
//   }

//   void searchProducts(String query) {
//     final newQuery = query.trim();
//     if (_currentSearchQuery == newQuery) return;
//     _currentSearchQuery = newQuery;
//     _applyFilters();
//   }

//   void applyCategoryFilter(String category) {
//     if (_selectedCategory == category) return;
//     _selectedCategory = category;
//     _applyFilters();
//   }

//   void applySortFilter(String sortOption) {
//     if (_selectedSort == sortOption) return;
//     _selectedSort = sortOption;
//     _applyFilters();
//   }

//   void applyDiscountFilter(int minDiscount) {
//     if (_minDiscountValue == minDiscount) return;
//     _minDiscountValue = minDiscount;
//     _applyFilters();
//   }

//   void resetFilters() {
//     _currentSearchQuery = '';
//     _selectedCategory = 'الأدوية';
//     _selectedSort = 'relevance';
//     _minDiscountValue = 0;
//     _applyFilters();
//   }

//   void _applyFilters() {
//     if (_allProducts.isEmpty) {
//       emit(ProductsSuccess(const []));
//       return;
//     }

//     Iterable<AddProductIntety> currentFilteredList = _allProducts;

//     currentFilteredList = currentFilteredList.where(
//       (product) => product.matchesCategory(_selectedCategory),
//     );

//     if (_currentSearchQuery.isNotEmpty) {
//       currentFilteredList = currentFilteredList.where(
//         (product) => product.matchesSearch(_currentSearchQuery),
//       );
//     }

//     if (_minDiscountValue > 0) {
//       currentFilteredList = currentFilteredList.where((product) {
//         return product.discountPercentage >= _minDiscountValue;
//       });
//     }

//     List<AddProductIntety> sortedList = currentFilteredList.toList();

//     switch (_selectedSort) {
//       case 'price_asc':
//         sortedList.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case 'price_desc':
//         sortedList.sort((a, b) => b.price.compareTo(a.price));
//         break;
//       default:
//         break;
//     }

//     emit(ProductsSuccess(sortedList));
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
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
  int get productsLength => _allProducts.length;
  
  List<AddProductIntety> _allProducts = [];
  List<AddProductIntety> _bestSellingProducts = []; 

  String _currentSearchQuery = '';
  // 🔹 تم تغيير القيمة الافتراضية إلى 'الكل' لضمان ظهور المنتج الجديد عند الفتح
  String _selectedCategory = 'الكل'; 
  String _selectedSort = 'relevance';
  num _minDiscountValue = 0;

  List<AddProductIntety> get allProducts => _allProducts;
  List<AddProductIntety> get bestSellingProducts => _bestSellingProducts; 
  String get selectedCategory => _selectedCategory;
  String get selectedSort => _selectedSort;
  num get minDiscountValue => _minDiscountValue;

  void fetchBestSelling({int topN = 10}) {
    productsRepo.fetchBestSellingProductsStream(topN: topN).listen((result) {
      result.fold(
        (failure) => emit(ProductsFailure(failure.message)),
        (products) {
          _bestSellingProducts = _getUniqueProducts(products);
          if (state is ProductsSuccess) {
            _applyFilters(); 
          } else if (state is ProductsInitial || state is ProductsLoading) {
             _allProducts = _bestSellingProducts;
             _applyFilters();
          }
        },
      );
    });
  }

  Future<void> getProducts() async {
    emit(ProductsLoading());
    final result = await productsRepo.getProducts();

    result.fold(
      (failure) => emit(ProductsFailure(failure.message)),
      (products) {
        _allProducts = _getUniqueProducts(products);
        _applyFilters();
      },
    );
  }

  List<AddProductIntety> _getUniqueProducts(List<AddProductIntety> allProducts) {
    final Map<String, AddProductIntety> uniqueMap = {};
    for (var item in allProducts) {
      if (!uniqueMap.containsKey(item.code)) {
        uniqueMap[item.code] = item;
      }
    }
    return uniqueMap.values.toList();
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
    _selectedCategory = 'الكل';
    _selectedSort = 'relevance';
    _minDiscountValue = 0;
    _applyFilters();
  }

  void _applyFilters() {
    List<AddProductIntety> sourceProducts = _allProducts.isNotEmpty 
        ? _allProducts 
        : _bestSellingProducts;

    if (sourceProducts.isEmpty) {
      emit(ProductsSuccess(const []));
      return;
    }

    Iterable<AddProductIntety> currentFilteredList = sourceProducts;

    // 🔹 التعديل: إذا كان القسم هو 'الكل' لا يتم تطبيق فلتر القسم
    if (_selectedCategory != 'الكل') {
      currentFilteredList = currentFilteredList.where(
        (product) => product.matchesCategory(_selectedCategory),
      );
    }

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
      default:
        break;
    }

    emit(ProductsSuccess(sortedList));
  }
}