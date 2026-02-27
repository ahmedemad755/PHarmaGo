import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/featchers/home/domain/enteties/BannerEntity.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/banners/banner_state.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PharmacyHomeScreenNew extends StatefulWidget {
  const PharmacyHomeScreenNew({super.key});

  @override
  State<PharmacyHomeScreenNew> createState() => _PharmacyHomeScreenNewState();
}

class _PharmacyHomeScreenNewState extends State<PharmacyHomeScreenNew> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  String _selectedCategory = 'الأدوية';
  List<String> _categories = ['الأدوية'];
  
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // استدعاء البيانات
    context.read<ProductsCubit>().getProducts();
    context.read<ProductsCubit>().fetchBestSelling();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ProductsCubit>().searchProducts(_searchController.text);
  }

  Future<void> _openFilterOptions() async {
    final productsCubit = context.read<ProductsCubit>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: productsCubit,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return PopScope(
                canPop: true,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) {}
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('تصفية البحث', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("الأقسام", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          children: _categories.map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: const Color(0xFF007BBB),
                              onSelected: (selected) {
                                if (selected) {
                                  setModalState(() => _selectedCategory = cat);
                                  productsCubit.applyCategoryFilter(cat);
                                }
                              },
                              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("ترتيب حسب", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      RadioListTile<String>(
                        value: 'relevance',
                        groupValue: productsCubit.selectedSort,
                        title: const Text('الأكثر صلة'),
                        activeColor: const Color(0xFF007BBB),
                        onChanged: (v) {
                          setModalState(() {});
                          productsCubit.applySortFilter(v!);
                        },
                      ),
                      RadioListTile<String>(
                        value: 'price_asc',
                        groupValue: productsCubit.selectedSort,
                        title: const Text('السعر: من الأقل للأعلى'),
                        activeColor: const Color(0xFF007BBB),
                        onChanged: (v) {
                          setModalState(() {});
                          productsCubit.applySortFilter(v!);
                        },
                      ),
                      RadioListTile<String>(
                        value: 'price_desc',
                        groupValue: productsCubit.selectedSort,
                        title: const Text('السعر: من الأعلى للأقل'),
                        activeColor: const Color(0xFF007BBB),
                        onChanged: (v) {
                          setModalState(() {});
                          productsCubit.applySortFilter(v!);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BBB),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('تم', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    return BlocProvider(
      create: (context) => getIt<BannersCubit>()..getBanners(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: RefreshIndicator(
          onRefresh: () async {
        await context.read<ProductsCubit>().getProducts();
        context.read<ProductsCubit>().fetchBestSelling();
      },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 10)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHomeAppBar(),
                      const SizedBox(height: 16),
                      _buildSearchBarWithFilter(),
                      const SizedBox(height: 18),
                      _buildUploadPrescription(isMobile),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildBannersSlider(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('الأقسام', horizontalPadding, onSeeAll: null),
                    const SizedBox(height: 12),
                    _buildCategoriesList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('الأكثر مبيعاً', horizontalPadding, onSeeAll: () {}),
                    const SizedBox(height: 12),
                    _buildHorizontalProductsList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const Text('اكتشف منتجاتنا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
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

  Widget _buildSectionTitle(String title, double padding, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text('عرض الكل', style: TextStyle(color: Color(0xFF007BBB), fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildBannersSlider() {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        if (state is GetBannersLoading) {
          return _buildBannerPlaceholder(isLoading: true);
        } else if (state is GetBannersSuccess) {
          final banners = state.banners;
          if (banners.isEmpty) return const SizedBox();
          return Column(
            children: [
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _bannerController,
                  onPageChanged: (index) => setState(() => _currentBannerIndex = index),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return GestureDetector(
                      onTap: () => _onBannerTap(banner),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            banner.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentBannerIndex == index ? 18 : 8,
                    decoration: BoxDecoration(
                      color: _currentBannerIndex == index ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _onBannerTap(BannerEntity banner) {
    if (banner.linkType == 'product' && banner.targetId != null) {
      // Navigator.pushNamed(context, AppRoutes.productDetails, arguments: banner.targetId);
    } else if (banner.linkType == 'category' && banner.targetId != null) {}
  }

  Widget _buildBannerPlaceholder({required bool isLoading}) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _categories = snapshot.data!.docs.map((doc) => doc['name'].toString()).toList();
          if (!_categories.contains('الأدوية')) _categories.insert(0, 'الأدوية');
        }
        return SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat);
                  context.read<ProductsCubit>().applyCategoryFilter(cat);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isSelected ? const Color(0xFF007BBB) : const Color(0xFFF2F6F8),
                      child: Text(cat.substring(0, 1), style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF007BBB))),
                    ),
                    const SizedBox(height: 8),
                    Text(cat, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHorizontalProductsList() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final cubit = context.read<ProductsCubit>();
        final horizontalList = cubit.bestSellingProducts.take(5).toList();

        if (horizontalList.isEmpty && state is ProductsLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (horizontalList.isEmpty) {
          return const SizedBox(
            height: 50,
            child: Center(child: Text("لا توجد منتجات أكثر مبيعاً حالياً")),
          );
        }

        return SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: horizontalList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = horizontalList[index];
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: product.imageurl != null 
                              ? Image.network(
                                  product.imageurl!, 
                                  fit: BoxFit.cover, 
                                  errorBuilder: (_, __, ___) => const Icon(Icons.medication, size: 40),
                                )
                              : const Icon(Icons.medication, size: 40),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), 
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${product.price} ج', 
                              style: const TextStyle(
                                color: Color(0xFF007BBB), 
                                fontWeight: FontWeight.bold, 
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchBarWithFilter() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(hintText: 'ابحث عن دواء أو منتج...', border: InputBorder.none),
            ),
          ),
          const VerticalDivider(indent: 10, endIndent: 10),
          IconButton(icon: const Icon(Icons.filter_list, color: Color(0xFF007BBB)), onPressed: _openFilterOptions),
        ],
      ),
    );
  }

  Widget _buildUploadPrescription(bool isMobile) {
    return GlassCard(
      width: double.infinity,
      height: isMobile ? 70 : 85,
      borderRadius: 16,
      opacity: 0.9,
      gradientColors: const [Color(0xFFE3F2FD), Color(0xFFF1F8E9)],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, color: Color(0xFF007BBB), size: 30),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('هل لديك روشتة؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('ارفعها الآن وسنوفر لك الأدوية', style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.uploadPrescription),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007BBB)),
              child: const Text("رفع", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}