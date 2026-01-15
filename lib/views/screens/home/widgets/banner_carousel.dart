import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/home_controller.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Obx(
            () => PageView.builder(
              itemCount: controller.banners.length,
              controller: PageController(viewportFraction: 0.9),
              onPageChanged: controller.onBannerPageChanged,
              itemBuilder: (context, index) {
                final banner = controller.banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          // Full Background Image
                          CachedNetworkImage(
                            imageUrl: banner.image,
                            fit: BoxFit.fill,
                            errorWidget: (c, o, s) => Container(
                              color: const Color(0xFF3B6EDE),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF00AEB3),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Indicators
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.banners.length, (index) {
              final isSelected = index == controller.currentBannerIndex.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: isSelected ? 24 : 8,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00AEB3)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
