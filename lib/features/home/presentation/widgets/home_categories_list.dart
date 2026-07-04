import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCategoriesList extends StatefulWidget {
  const HomeCategoriesList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onCategoriesFetched,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<List<String>> onCategoriesFetched;

  @override
  State<HomeCategoriesList> createState() => _HomeCategoriesListState();
}

class _HomeCategoriesListState extends State<HomeCategoriesList> {
  List<String> _categories = ['الكل'];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fetched = snapshot.data!.docs
              .map((doc) => doc['name'].toString())
              .toList();
          if (_categories.length != fetched.length + 1) {
            _categories = ['الكل', ...fetched];
            // نبلغ الشاشة الأب بالقائمة الجديدة بعد انتهاء الـ build الحالي
            // لتفادي استدعاء setState أثناء الـ build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onCategoriesFetched(_categories);
            });
          }
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
              final isSelected = widget.selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  widget.onCategorySelected(cat);
                  context.read<ProductsCubit>().applyCategoryFilter(cat);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : const Color(0xFFF2F6F8),
                      child: cat == 'الكل'
                          ? Icon(
                              Icons.apps,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                            )
                          : Text(
                              cat.substring(0, 1),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
}
