import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/utils/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomNavBar(this.iconName, {Key? key, this.color, this.size})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (iconName) {
      case 'Home':
        iconData = Icons.home_rounded;
        break;
      case 'profile':
        iconData = Icons.person_rounded;
        break;
      default:
        iconData = Icons.error_outline_rounded;
    }
    return Icon(iconData, color: color, size: size?.sp ?? 24.sp);
  }
}

class NavItem {
  NavItem({
    required this.icon,
    required this.selectedIcon,
    this.label,
    this.onTap,
  });
  String? label;
  Widget icon;
  Widget selectedIcon;
  void Function()? onTap;
}

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Color color;
  final List<NavItem> navItems;

  const NavBar({
    super.key,
    this.selectedIndex = 0,
    required this.navItems,
    this.color = AppColors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 24.h),
      child: Center(
        child: Container(
          width: ((navItems.length * 100.0) + 16).w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20.r,
                offset: Offset(0, 8.h),
              ),
              BoxShadow(
                color: AppColors.teal.withValues(alpha: 0.02),
                blurRadius: 4.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(navItems.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: navItems[index].onTap,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 90.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),
                      isSelected ? navItems[index].selectedIcon : navItems[index].icon,
                      SizedBox(height: 6.h),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 18.w : 0.w,
                        height: 3.5.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
