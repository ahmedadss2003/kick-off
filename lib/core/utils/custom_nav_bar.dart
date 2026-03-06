import 'package:flutter/material.dart';
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
        iconData = Icons.person;
        break;
      default:
        iconData = Icons.error;
    }
    return Icon(iconData, color: color, size: size);
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

// ignore: must_be_immutable
class NavBar extends StatelessWidget {
  NavBar({
    super.key,
    this.selectedIndex = 0,
    required this.navItems,
    this.color = AppColors.teal,
  });
  final int selectedIndex;
  final Color color;
  final List<NavItem> navItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(200),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: List.generate(navItems.length, (index) {
                final isSelected = index == selectedIndex;
                return Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: navItems[index].onTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 51.68,
                      height: 51.68,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withAlpha(26)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? navItems[index].selectedIcon
                          : navItems[index].icon,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
