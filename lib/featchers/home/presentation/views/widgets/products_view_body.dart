import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
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
  @override
  void initState() {
    context.read<ProductsCubit>().getProducts();
    _searchController.addListener(_onSearchChanged);
    context.read<ProductsCubit>().fetchBestSelling();
    super.initState();
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
  void dispose() {
    // 5. Clean up the controller and listener
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(context, title: 'المنتجات', showBackButton: false),
            SizedBox(height: kTopPaddding),
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
                      controller: _searchController, // <-- Use the controller
                      textDirection: TextDirection.rtl, // For Arabic input
                      textAlign: TextAlign.right, // For Arabic input
                      decoration: InputDecoration(
                        hintText: "ابحث عن منتج...",
                        hintStyle: const TextStyle(color: Colors.black45),
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
                    icon: const Icon(Icons.filter_list, color: Colors.black54),
                    onPressed:
                        _openFilterOptions, // <-- Interactive filter button
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            // ProductsHeader(
            //   productsLength: context.read<ProductsCubit>().productsLength,
            // ),
            SizedBox(height: 12),
            ProductsGridViewBlocBuilder(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          ],
        ),
      ),
    );
  }
}
