import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/Features/home/presentation/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/Features/home/presentation/cubits/banners/banner_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeBannersSlider extends StatefulWidget {
  const HomeBannersSlider({super.key});

  @override
  State<HomeBannersSlider> createState() => _HomeBannersSliderState();
}

class _HomeBannersSliderState extends State<HomeBannersSlider> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        if (state is GetBannersLoading) {
          return _buildPlaceholder(isLoading: true);
        }
        if (state is GetBannersSuccess) {
          final banners = state.banners;
          if (banners.isEmpty) return const SizedBox();
          return Column(
            children: [
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _bannerController,
                  onPageChanged: (index) =>
                      setState(() => _currentBannerIndex = index),
                  itemCount: banners.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        banners[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                      color: _currentBannerIndex == index
                          ? AppColors.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPlaceholder({required bool isLoading}) => Skeletonizer(
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
