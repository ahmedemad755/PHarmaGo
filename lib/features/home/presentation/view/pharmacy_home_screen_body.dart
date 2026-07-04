import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/openGeneralFilter_in_home_products.dart';
import 'package:e_commerce/Features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/core/widgets/custom_search_filter_bar_home_products.dart';
import 'package:e_commerce/Features/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/Features/home/presentation/widgets/custom_home_app_bar.dart';
import 'package:e_commerce/Features/home/presentation/widgets/home_banners_slider.dart';
import 'package:e_commerce/Features/home/presentation/widgets/home_best_selling_products_list.dart';
import 'package:e_commerce/Features/home/presentation/widgets/home_categories_list.dart';
import 'package:e_commerce/Features/home/presentation/widgets/home_section_title.dart';
import 'package:e_commerce/Features/home/presentation/widgets/home_upload_prescription_card.dart';
import 'package:e_commerce/Features/products/presentation/widgets/products_grid_view_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PharmacyHomeScreenNew extends StatefulWidget {
  const PharmacyHomeScreenNew({super.key});

  @override
  State<PharmacyHomeScreenNew> createState() => _PharmacyHomeScreenNewState();
}

class _PharmacyHomeScreenNewState extends State<PharmacyHomeScreenNew> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'الكل';
  List<String> _categories = ['الكل'];

  @override
  void initState() {
    super.initState();
    // جلب البيانات فوراً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productsCubit = context.read<ProductsCubit>();
      productsCubit.getProducts();
      productsCubit.fetchBestSelling();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width < 600
        ? 16.0
        : 24.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<BannersCubit>()..getBanners()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductsCubit>().getProducts();
            context.read<BannersCubit>().getBanners();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top + 10,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHomeAppBar(),
                      const SizedBox(height: 16),

                      // استخدام ويدجيت البحث والفلترة الخارجية
                      CustomSearchFilterBar(
                        controller: _searchController,
                        onSearchChanged: (value) {
                          context.read<ProductsCubit>().searchProducts(value);
                        },
                        onFilterTap: () {
                          // استخدام دالة المودال الخارجية
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

                      const SizedBox(height: 18),
                      const HomeUploadPrescriptionCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: HomeBannersSlider()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeSectionTitle('الأقسام', horizontalPadding),
                    const SizedBox(height: 12),
                    HomeCategoriesList(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) {
                        setState(() => _selectedCategory = cat);
                      },
                      onCategoriesFetched: (fetched) {
                        setState(() => _categories = fetched);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeSectionTitle(
                      'الأكثر مبيعاً',
                      horizontalPadding,
                      onSeeAll: () {},
                    ),
                    const SizedBox(height: 12),
                    const HomeBestSellingProductsList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const Text(
                    'اكتشف منتجاتنا',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12,
                ),
                sliver: const SliverToBoxAdapter(
                  child: ProductsGridViewBlocBuilder(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
