import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/functions_helper/openGeneralFilter_in_home_products.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/custom_search_filter_bar_home_products.dart';
import 'package:e_commerce/featchers/auth/widgets/app_bar_about_pages.dart';
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
  String _selectedCategory = 'الكل';
  List<String> _categories = ['الكل'];

  @override
  void initState() {
    super.initState();
    // تنفيذ الجلب الأولي للبيانات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProductsCubit>();
      cubit.getProducts();
      cubit.fetchBestSelling();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // لون خلفية هادئ
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarAboutPages(title: "المنتجات"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async => context.read<ProductsCubit>().getProducts(),
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // استخدام الويدجيت المستخرجة (Search + Filter)
                  CustomSearchFilterBar(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      context.read<ProductsCubit>().searchProducts(value);
                    },
                    onFilterTap: () {
                      // استخدام دالة الفلترة العامة المستخرجة
                      openGeneralFilterModal(
                        context: context,
                        productsCubit: context.read<ProductsCubit>(),
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (cat) {
                          setState(() => _selectedCategory = cat);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('الأقسام'),
                  const SizedBox(height: 12),
                  _buildCategoriesList(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('كل المنتجات'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // شبكة المنتجات
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: ProductsGridViewBlocBuilder(),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ميثود الأقسام (تستخدم StreamBuilder لجلب الأقسام من Firebase)
  Widget _buildCategoriesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fetched = snapshot.data!.docs.map((doc) => doc['name'].toString()).toList();
          // تحديث القائمة المحلية
          if (_categories.length != fetched.length + 1) {
             _categories = ['الكل', ...fetched];
          }
        }

        return SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => _buildCategoryItem(_categories[index]),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(String cat) {
    final isSelected = _selectedCategory == cat;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = cat);
        context.read<ProductsCubit>().applyCategoryFilter(cat);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          cat,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkGray,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}