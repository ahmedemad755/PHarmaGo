import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart'; 
import 'package:e_commerce/core/enteties/product_enteti.dart'; 
import 'package:e_commerce/core/errors/faliur.dart'; 
import 'package:e_commerce/core/repos/products_repo/products_repo.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

// --- Extension for clean search matching ---
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
// ------------------------------------------

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  int productsLength = 0;
  
  List<AddProductIntety> _allProducts = []; 
  
  // --- حالة الفلاتر ---
  String _currentSearchQuery = '';
  String _selectedCategory = 'الأدوية'; 
  String _selectedSort = 'relevance'; 
  // تم تعريفه كـ num ليتوافق مع الموديل
  num _minDiscountValue = 0; 

  List<AddProductIntety> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  String get selectedSort => _selectedSort;
  num get minDiscountValue => _minDiscountValue; 
  
  
  // --- Core Data Fetching Methods ---

  Future<void> getProducts() async {
    emit(ProductsLoading());
    final Either<Faliur, List<AddProductIntety>> result = 
        await productsRepo.getProducts(); 
        
    result.fold(
      (failure) => emit(ProductsFailure(failure.message)),
      (products) {
        _allProducts = products; 
        _applyFilters(); // تطبيق الفلاتر على البيانات التي تم جلبها
      },
    );
  }

  Future<void> fetchBestSelling({int topN = 10}) async {
    emit(ProductsLoading());
    final Either<Faliur, List<AddProductIntety>> result =
        await productsRepo.getBestSellingProducts(topN: topN);

    result.fold(
      (failure) => emit(ProductsFailure(failure.message)),
      (products) {
        _allProducts = products; 
        _applyFilters(); // تطبيق الفلاتر على البيانات التي تم جلبها
      },
    );
  }

  // --- Search and Filtering Methods ---

  void searchProducts(String query) {
    final newQuery = query.trim();
    if (_currentSearchQuery == newQuery) return;
    
    _currentSearchQuery = newQuery;
    _applyFilters(); // ⬅️ تطبيق التغيير فورًا
  }

  void applyCategoryFilter(String category) {
    if (_selectedCategory == category) return;
    
    _selectedCategory = category;
    _applyFilters(); // ⬅️ تطبيق التغيير فورًا
  }

  void applySortFilter(String sortOption) {
    if (_selectedSort == sortOption) return;
    
    _selectedSort = sortOption;
    _applyFilters(); // ⬅️ تطبيق التغيير فورًا
  }

  // 💡 تم التعديل: تطبيق فلتر الخصم
  void applyDiscountFilter(int minDiscount) {
    if (_minDiscountValue == minDiscount) return;
    
    // تخزين القيمة الرقمية المرسلة
    _minDiscountValue = minDiscount;
    
    _applyFilters(); // ⬅️ تطبيق التغيير الحاسم
  }

  void resetFilters() {
    _currentSearchQuery = '';
    _selectedCategory = 'الأدوية';
    _selectedSort = 'relevance';
    _minDiscountValue = 0; 
    _applyFilters(); // ⬅️ تطبيق إعادة التعيين
  }

  /// Applies all active filters (search, category, sort, discount, etc.)
  void _applyFilters() {
    if (_allProducts.isEmpty) {
      emit(ProductsSuccess(const []));
      return;
    }
    
    // 1. Start with the full list
    Iterable<AddProductIntety> currentFilteredList = _allProducts;

    // 2. Apply Category Filter
    currentFilteredList = currentFilteredList.where(
      (product) => product.matchesCategory(_selectedCategory),
    );
    
    // 3. Apply Search Filter
    if (_currentSearchQuery.isNotEmpty) {
      currentFilteredList = currentFilteredList.where(
        (product) => product.matchesSearch(_currentSearchQuery),
      );
    }

    // 4. 💡 تطبيق فلتر الخصم
    if (_minDiscountValue > 0) {
      currentFilteredList = currentFilteredList.where((product) {
        // المقارنة بين خصم المنتج (num) والقيمة الدنيا المطلوبة (num)
        return product.discountPercentage >= _minDiscountValue; 
      });
    }
    
    // 5. Apply Sort Filter: التحويل إلى قائمة لعمل الـ sort
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

    // 6. Emit the final result
    emit(ProductsSuccess(sortedList));
  }
}