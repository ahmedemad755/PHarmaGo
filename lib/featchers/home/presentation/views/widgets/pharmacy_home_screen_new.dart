import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/featchers/auth/presentation/view/login_view%20copy.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Placeholder for AppColors (Replace with your actual import/definition) ---
// Note: This placeholder is necessary for the code to compile since

// --- Placeholder Models ---
class Pharmacy {
  final String id;
  final String name;
  final String discount;

  Pharmacy({required this.id, required this.name, required this.discount});
}

// --- Pharmacy Home Screen Widget ---

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

  void _selectPharmacy(Pharmacy pharmacy) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📦 Selected: ${pharmacy.name}'),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  // 2. Search Change Handler
  void _onSearchChanged() {
    // Call the Cubit's search method with the current text
    context.read<ProductsCubit>().searchProducts(_searchController.text);
    // Trigger a rebuild so the search field's clear button updates
    setState(() {});
  }

  // 3. Filter Icon Handler
  // 3. Filter Icon Handler (MODIFIED)
  Future<void> _openFilterOptions() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        // Local temporary values for the modal
        String tempCategory = _selectedCategory;
        String tempSort = 'relevance';
        // 💡 تم التعديل: استخدام قيمة الخصم بدلاً من منطق (صحيح/خطأ)
        double minDiscountValue = 0.0;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                          color: Colors.grey[300],
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Categories
                    const Text(
                      'الفئة',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSelected = tempCategory == cat;
                        return ChoiceChip(
                          label: Text(cat, textDirection: TextDirection.rtl),
                          selected: isSelected,
                          onSelected: (_) =>
                              setModalState(() => tempCategory = cat),
                          selectedColor: const Color(0xFF007BBB),
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // Sort options
                    const Text(
                      'ترتيب حسب',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: 'relevance',
                      groupValue: tempSort,
                      onChanged: (v) =>
                          setModalState(() => tempSort = v ?? 'relevance'),
                      title: const Text('الأكثر صلة'),
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: 'price_asc',
                      groupValue: tempSort,
                      onChanged: (v) =>
                          setModalState(() => tempSort = v ?? 'price_asc'),
                      title: const Text('السعر من الأقل للأعلى'),
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: 'price_desc',
                      groupValue: tempSort,
                      onChanged: (v) =>
                          setModalState(() => tempSort = v ?? 'price_desc'),
                      title: const Text('السعر من الأعلى للأقل'),
                    ),

                    const SizedBox(height: 8),

                    // // 💡 تمت الإضافة: Slider لنسبة الخصم
                    // const Text('الحد الأدنى للخصم', style: TextStyle(fontWeight: FontWeight.w600)),
                    // const SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       '${minDiscountValue.round()}%',
                    //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF007BBB)),
                    //     ),
                    //     Expanded(
                    //       child: Slider(
                    //         value: minDiscountValue,
                    //         min: 0,
                    //         max: 50,
                    //         divisions: 10,
                    //         label: '${minDiscountValue.round()}%',
                    //         activeColor: const Color(0xFF007BBB),
                    //         inactiveColor: Colors.grey[300],
                    //         onChanged: (double newValue) {
                    //           setModalState(() {
                    //             minDiscountValue = newValue;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // ------------------------------------------
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // 🛑 التعديل هنا: استدعاء دالة resetFilters() في الـ Cubit
                              context.read<ProductsCubit>().resetFilters();

                              // إغلاق الـ Modal Bottom Sheet بعد إعادة التعيين
                              Navigator.of(context).pop();

                              // تحديث الحالة المحلية لشاشة الـ Home لتنعكس فئة الأدوية الافتراضية
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
                                // 💡 تم التعديل: إرسال القيمة كرقم صحيح
                                'minDiscountValue': minDiscountValue.round(),
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BBB),
                            ),
                            child: const Text(
                              'تطبيق',
                              style: TextStyle(color: Colors.white),
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

    // Apply the returned filters if any
    if (result != null) {
      // ignore: avoid_print
      print('Filter result: $result');

      if (!mounted) return;

      setState(() {
        _selectedCategory = result['category'] ?? _selectedCategory;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Apply all filters to ProductsCubit
          context.read<ProductsCubit>().applyCategoryFilter(_selectedCategory);
          context.read<ProductsCubit>().applySortFilter(
            result['sort'] ?? 'relevance',
          );
          // 💡 تم التعديل: إرسال الحد الأدنى للخصم (الرقم)
          context.read<ProductsCubit>().applyDiscountFilter(
            result['minDiscountValue'] ?? 0,
          );
        } catch (_) {
          // ignore: no-empty
        }

        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'تم تطبيق الفلاتر: ${result['category']} - ${result['sort']} - خصم ${result['minDiscountValue']}%',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    // 4. Attach listener to the controller in initState
    _searchController.addListener(_onSearchChanged);
    context.read<ProductsCubit>().fetchBestSelling();
    super.initState();
  }

  @override
  void dispose() {
    // 5. Clean up the controller and listener
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        // FIX: Replaced SingleChildScrollView with CustomScrollView
        // to correctly contain the GridView as a Box within a Sliver context.
        child: CustomScrollView(
          slivers: [
            // 1. SliverToBoxAdapter for ALL static content (AppBar, Search, Promo, Upload, Categories, Pharmacies)
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

                    // --- ENHANCED SEARCH BAR IMPLEMENTATION ---
                    Container(
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
                              controller:
                                  _searchController, // <-- Use the controller
                              textDirection:
                                  TextDirection.rtl, // For Arabic input
                              textAlign: TextAlign.right, // For Arabic input
                              decoration: InputDecoration(
                                hintText: "ابحث عن منتج...",
                                hintStyle: const TextStyle(
                                  color: Colors.black45,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                // Show a clear button when there is text
                                suffixIcon: _searchController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.clear, size: 20),
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
                          // Filter Icon Button
                          IconButton(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.black54,
                            ),
                            onPressed:
                                _openFilterOptions, // <-- Interactive filter button
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),

                    // ------------------------------------------
                    const SizedBox(height: 16),

                    // Promo
                    GlassCard(
                      width: double.infinity,
                      height: isMobile ? 150 : 170,
                      borderRadius: 20,
                      opacity: 0.95,
                      gradientColors: const [
                        Color(0xFFF2F6F8),
                        Color(0xFFF2F6F8),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'خصم 15%',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'صيدلية قريبة منك',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'توصيل لحد باب البيت',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: isMobile ? 34 : 40,
                              backgroundColor: const Color(0xFFBEEFFF),
                              child: const Icon(
                                Icons.local_pharmacy,
                                size: 28,
                                color: Color(0xFF007BBB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Upload prescription
                    GlassCard(
                      width: double.infinity,
                      height: isMobile ? 65 : 75,
                      borderRadius: 16,
                      opacity: 0.95,
                      gradientColors: const [
                        Color(0xFFF2F6F8),
                        Color(0xFFF2F6F8),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    'ارفع الروشتة الخاصة بك',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.uploadPrescription,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9ABEDC),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "رفع",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Categories Title
                    const Text(
                      "الفئات",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Categories List
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        // FIX: Added physics to prevent nested scrolling conflict
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (String cat in _categories)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: _categoryChip(
                                cat,
                                _selectedCategory == cat,
                                () {
                                  setState(() {
                                    _selectedCategory = cat;
                                  });
                                  // Apply category filter immediately via cubit
                                  try {
                                    context
                                        .read<ProductsCubit>()
                                        .applyCategoryFilter(cat);
                                  } catch (_) {
                                    // ignore: no-empty
                                  }
                                  // Show SnackBar feedback
                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم اختيار: $cat'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Local Pharmacies Title
                    const Text(
                      'الصيدليات المحلية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Local Pharmacies List
                    SizedBox(
                      height: isMobile ? 110 : 130,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        // FIX: Added physics to prevent nested scrolling conflict
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (Pharmacy pharmacy in _pharmacies)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _pharmacyCard(pharmacy, isMobile),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Best Selling Title
                    const Text(
                      'الاكثر مبيعا',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // 2. Products Grid: Wrap the Grid Builder in a SliverToBoxAdapter
            // to conform to the CustomScrollView (Sliver) structure.
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const ProductsGridViewBlocBuilder(limit: 4),
              ),
            ),

            // 3. Final Spacer (as a Sliver)
            // مسافة سفلية إضافية حتى لا يختبئ آخر كرت منتج خلف الـ BottomNavigationBar
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.12 + 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Unchanged) ---
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
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFBEEFFF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.circle,
                size: 10,
                color: isSelected
                    ? const Color(0xFF007BBB)
                    : const Color(0xFF007BBB),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
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
              Flexible(
                child: Center(
                  child: Icon(
                    Icons.local_pharmacy,
                    size: isMobile ? 28 : 32,
                    color: const Color(0xFF007BBB),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pharmacy.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  GestureDetector(
                    onTap: () => _selectPharmacy(pharmacy),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007BBB),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
