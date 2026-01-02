import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/theming/colors.dart';

class BuildHeadder extends StatelessWidget {
  const BuildHeadder({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://imgs.search.brave.com/aToBhFXCfMQKa5xBsAfc3dA5HBMWyUnYp-P5vnV5u4I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9teW1v/ZGVybm1ldC5jb20v/d3Avd3AtY29udGVu/dC91cGxvYWRzLzIw/MjIvMTEvMjAyMi13/b3JsZC1jdXAtYmFs/bHMtdGVjaG5vbG9n/eS0xLmpwZw',
                //"https://images.unsplash.com/photo-1551958219-acbc608c6377?q=80&amp;w=1000&amp;auto=format&amp;fit=crop",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40.h,
          child: Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(
              color: ColorsManager.mainColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.mainColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
