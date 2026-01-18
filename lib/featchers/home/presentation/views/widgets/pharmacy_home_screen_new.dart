import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ===================== MODEL =====================

class Pharmacy {
  final String id;
  final String name;
  final String discount;

  Pharmacy({required this.id, required this.name, required this.discount});
}

// ===================== SCREEN =====================

class PharmacyHomeScreenNew extends StatefulWidget {
  const PharmacyHomeScreenNew({super.key});

  @override
  State<PharmacyHomeScreenNew> createState() => _PharmacyHomeScreenNewState();
}

class _PharmacyHomeScreenNewState extends State<PharmacyHomeScreenNew> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'الأدوية';

  final List<String> _categories = ['الأدوية', 'أجهزة صحية'];

  final List<Pharmacy> _pharmacies = [
    Pharmacy(id: '1', name: 'Health Plus', discount: '15% off'),
    Pharmacy(id: '2', name: 'MediCare', discount: '20% off'),
    Pharmacy(id: '3', name: 'PharmaPro', discount: '10% off'),
  ];

  // ===================== LIFECYCLE =====================

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<ProductsCubit>().fetchBestSelling();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // ===================== LOGIC =====================

  void _selectPharmacy(Pharmacy pharmacy) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📦 Selected: ${pharmacy.name}'),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _onSearchChanged() {
    context.read<ProductsCubit>().searchProducts(_searchController.text);
    setState(() {});
  }

  Future<void> _openFilterOptions() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String tempCategory = _selectedCategory;
        String tempSort = 'relevance';

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'تصفية البحث',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: _categories.map((cat) {
                      return ChoiceChip(
                        label: Text(cat),
                        selected: tempCategory == cat,
                        selectedColor: const Color(0xFF007BBB),
                        onSelected: (_) =>
                            setModalState(() => tempCategory = cat),
                        labelStyle: TextStyle(
                          color: tempCategory == cat
                              ? Colors.white
                              : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile(
                    value: 'relevance',
                    groupValue: tempSort,
                    onChanged: (v) => setModalState(() => tempSort = v!),
                    title: const Text('الأكثر صلة'),
                  ),
                  RadioListTile(
                    value: 'price_asc',
                    groupValue: tempSort,
                    onChanged: (v) => setModalState(() => tempSort = v!),
                    title: const Text('السعر من الأقل للأعلى'),
                  ),
                  RadioListTile(
                    value: 'price_desc',
                    groupValue: tempSort,
                    onChanged: (v) => setModalState(() => tempSort = v!),
                    title: const Text('السعر من الأعلى للأقل'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BBB),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {
                        'category': tempCategory,
                        'sort': tempSort,
                      });
                    },
                    child: const Text(
                      'تطبيق',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result == null) return;

    setState(() {
      _selectedCategory = result['category'];
    });

    context.read<ProductsCubit>().applyCategoryFilter(_selectedCategory);
    context.read<ProductsCubit>().applySortFilter(result['sort']);
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHomeAppBar(),
                    _buildSearchBarWithFilter(),
                    const SizedBox(height: 18),
                    uploadPrescription(isMobile),
                    const SizedBox(height: 18),
                    _buildCategories(),
                    const SizedBox(height: 18),
                    _buildPharmacies(isMobile),
                    const SizedBox(height: 18),
                    const Text(
                      'الاكثر مبيعا',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const ProductsGridViewBlocBuilder(limit: 4),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ===================== SECTIONS =====================

  Widget _buildSearchBarWithFilter() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'ابحث عن منتج...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black54),
            onPressed: _openFilterOptions,
          ),
        ],
      ),
    );
  }

  Widget uploadPrescription(bool isMobile) {
    return GlassCard(
      width: double.infinity,
      height: isMobile ? 65 : 75,
      borderRadius: 16,
      opacity: 0.95,
      gradientColors: const [Color(0xFFF2F6F8), Color(0xFFF2F6F8)],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFBEEFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.upload_file,
                color: Color(0xFF007BBB),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'اطلب عبر الروشتة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  Text(
                    'ارفع الروشتة الخاصة بك',
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.uploadPrescription);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9ABEDC),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "رفع",
                style: TextStyle(color: Colors.black87, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((cat) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: _categoryChip(cat, _selectedCategory == cat, () {
              setState(() => _selectedCategory = cat);
              context.read<ProductsCubit>().applyCategoryFilter(cat);
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPharmacies(bool isMobile) {
    return SizedBox(
      height: isMobile ? 110 : 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _pharmacies.map((pharmacy) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _pharmacyCard(pharmacy, isMobile),
          );
        }).toList(),
      ),
    );
  }

  // ===================== HELPERS =====================

  Widget _categoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BBB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF007BBB),
            width: isSelected ? 0 : 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _pharmacyCard(Pharmacy pharmacy, bool isMobile) {
    return GestureDetector(
      onTap: () => _selectPharmacy(pharmacy),
      child: GlassCard(
        width: isMobile ? 135 : 155,
        height: isMobile ? 110 : 130,
        borderRadius: 16,
        opacity: 0.95,
        gradientColors: const [Color(0xFFF2F6F8), Color(0xFFF2F6F8)],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  pharmacy.discount,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007BBB),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.local_pharmacy,
                  size: isMobile ? 28 : 32,
                  color: const Color(0xFF007BBB),
                ),
              ),
              Text(
                pharmacy.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
