import 'package:flutter/material.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/core/utils/custom_nav_bar.dart';
import 'package:kickoff/features/stadiums/presentation/ui/stadiums_view.dart';
import 'package:kickoff/features/profile/presentation/profile_view.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [StadiumsView(), ProfileView()];

  final List<String> _iconNames = ['Home', 'profile'];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SizedBox(
        height: 115,
        child: NavBar(
          selectedIndex: _currentIndex,
          color: AppColors.teal,
          navItems: List.generate(_pages.length, (index) {
            final iconName = _iconNames[index];
            return NavItem(
              icon: CustomNavBar(iconName, color: Colors.grey),
              selectedIcon: CustomNavBar(
                iconName,
                color: AppColors.teal,
                size: 31.68,
              ),
              onTap: () => _onItemTapped(index),
            );
          }),
        ),
      ),
    );
  }
}
