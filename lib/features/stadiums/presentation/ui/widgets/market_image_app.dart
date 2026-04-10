import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MarkingImageScreen extends StatefulWidget {
  const MarkingImageScreen({super.key});

  @override
  State<MarkingImageScreen> createState() => _MarkingImageScreenState();
}

class _MarkingImageScreenState extends State<MarkingImageScreen> {
  final List<String> imgList = [
    'assets/images/marketin_image1.jpeg',
    'assets/images/marketing_image2.jpeg',
    'assets/images/WhatsApp Image 2026-04-03 at 10.19.55 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-04-03 at 10.19.55 PM.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          enlargeCenterPage: true,

          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        items: imgList
            .map(
              (item) => Container(
                child: Center(
                  child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
