import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> openGeneralFilterModal({
  required BuildContext context,
  required ProductsCubit productsCubit,
  required List<String> categories,
  required String selectedCategory,
  required Function(String) onCategorySelected,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) {
      return BlocProvider.value(
        value: productsCubit,
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 16, left: 20, right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  const Center(child: Text('تصفية النتائج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 20),
                  const Text("الأقسام", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: const Color(0xFF007BBB),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => selectedCategory = cat);
                            onCategorySelected(cat);
                            productsCubit.applyCategoryFilter(cat);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("ترتيب حسب", style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildSortItem(productsCubit, setModalState, 'relevance', 'الأكثر صلة'),
                  _buildSortItem(productsCubit, setModalState, 'price_asc', 'السعر: من الأقل للأعلى'),
                  _buildSortItem(productsCubit, setModalState, 'price_desc', 'السعر: من الأعلى للأقل'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BBB),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('تطبيق', style: TextStyle(color: Colors.white)),
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

Widget _buildSortItem(ProductsCubit cubit, StateSetter setState, String value, String title) {
  return RadioListTile<String>(
    value: value,
    groupValue: cubit.selectedSort,
    title: Text(title, style: const TextStyle(fontSize: 14)),
    activeColor: const Color(0xFF007BBB),
    contentPadding: EdgeInsets.zero,
    onChanged: (v) {
      setState(() {});
      cubit.applySortFilter(v!);
    },
  );
}