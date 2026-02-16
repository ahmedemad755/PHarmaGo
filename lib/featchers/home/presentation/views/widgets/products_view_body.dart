import 'package:cloud_firestore/cloud_firestore.dart'; // تأكد من وجود هذا الاستيراد
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/auth/widgets/build_app_bar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsViewBody extends StatefulWidget {
  const ProductsViewBody({super.key});

  @override
  State<ProductsViewBody> createState() => _ProductsViewBodyState();
}

class _ProductsViewBodyState extends State<ProductsViewBody> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الأدوية';
  List<String> _categories = ['الأدوية'];

  @override
  void initState() {
    context.read<ProductsCubit>().getProducts();
    _searchController.addListener(_onSearchChanged);
    context.read<ProductsCubit>().fetchBestSelling();
    super.initState();
  }

  void _onSearchChanged() {
    context.read<ProductsCubit>().searchProducts(_searchController.text);
    setState(() {});
  }

  // --- ميثود بناء قائمة الأقسام الديناميكية ---
  Widget _buildCategoriesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _categories = snapshot.data!.docs
              .map((doc) => doc['name'].toString())
              .toList();

          if (!_categories.contains('الأدوية')) {
            _categories.insert(0, 'الأدوية');
          }
        }

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat);
                  context.read<ProductsCubit>().applyCategoryFilter(cat);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderColor,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.darkGray,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openFilterOptions() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String tempCategory = _selectedCategory;
        String tempSort = 'relevance';
        double minDiscountValue = 0.0;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.mediumGray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'تصفية البحث',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ترتيب حسب',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGray),
                    ),
                    RadioListTile<String>(
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      value: 'relevance',
                      groupValue: tempSort,
                      onChanged: (v) => setModalState(() => tempSort = v ?? 'relevance'),
                      title: const Text('الأكثر صلة'),
                    ),
                    RadioListTile<String>(
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      value: 'price_asc',
                      groupValue: tempSort,
                      onChanged: (v) => setModalState(() => tempSort = v ?? 'price_asc'),
                      title: const Text('السعر من الأقل للأعلى'),
                    ),
                    RadioListTile<String>(
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      value: 'price_desc',
                      groupValue: tempSort,
                      onChanged: (v) => setModalState(() => tempSort = v ?? 'price_desc'),
                      title: const Text('السعر من الأعلى للأقل'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              foregroundColor: AppColors.primary,
                            ),
                            onPressed: () {
                              context.read<ProductsCubit>().resetFilters();
                              Navigator.of(context).pop();
                              setState(() {
                                _selectedCategory = 'الأدوية';
                              });
                            },
                            child: const Text('إعادة تعيين'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop({
                                'category': tempCategory,
                                'sort': tempSort,
                                'minDiscountValue': minDiscountValue.round(),
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              'تطبيق',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      if (!mounted) return;
      setState(() {
        _selectedCategory = result['category'] ?? _selectedCategory;
      });
      // ... (باقي كود الفلترة كما هو)
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(context, title: 'المنتجات', showBackButton: false),
            SizedBox(height: kTopPaddding),
            
            // --- حقل البحث ---
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "ابحث عن منتج....",
                        hintStyle: const TextStyle(color: AppColors.mediumGray),
                        border: InputBorder.none,
                        isDense: true,
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear, size: 20, color: AppColors.darkGray),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged();
                                },
                              ),
                      ),
                      onSubmitted: (_) => _onSearchChanged(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.primary),
                    onPressed: _openFilterOptions,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // --- عرض الكاردات الخاصة بالكاتيجوري ---
            const Text(
              'الأقسام',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoriesList(), 
            
            const SizedBox(height: 24),
            
            // --- شبكة المنتجات ---
            const ProductsGridViewBlocBuilder(),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          ],
        ),
      ),
    );
  }
}