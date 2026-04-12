import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/utils/app_colors.dart';

class MarkingImageScreen extends StatefulWidget {
  const MarkingImageScreen({super.key});

  @override
  State<MarkingImageScreen> createState() => _MarkingImageScreenState();
}

class _MarkingImageScreenState extends State<MarkingImageScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> marketingItems = [
    {
      'image': 'assets/images/marketin_image1.jpeg',
      'title': 'أفضل الملاعب في مصر',
      'subtitle': 'احجز ملعبك المفضل الآن بكل سهولة',
    },
    {
      'image': 'assets/images/marketing_image2.jpeg',
      'title': 'خصومات حصرية',
      'subtitle': 'احصل على خصم 20% على أول حجز لك',
    },
    {
      'image':
          'assets/images/WhatsApp Image 2026-04-03 at 10.19.55 PM (1).jpeg',
      'title': 'تجمع مع أصحابك',
      'subtitle': 'نظم مباراتك القادمة واقضِ وقتاً ممتعاً',
    },
    {
      'image': 'assets/images/WhatsApp Image 2026-04-03 at 10.19.55 PM.jpeg',
      'title': 'ملاعب بجودة عالمية',
      'subtitle': 'استمتع بتجربة لعب لا تُنسى',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.h,
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            viewportFraction: 0.88,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: marketingItems.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: Stack(
                      children: [
                        Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          right: 20.w,
                          left: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle']!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: marketingItems.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 24.w : 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: _currentIndex == entry.key
                    ? AppColors.teal
                    : AppColors.teal.withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
