import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/core/utils/custom_nav_bar.dart';
import 'package:kickoff/features/stadiums/presentation/ui/stadiums_view.dart';
import 'package:kickoff/features/profile/presentation/profile_view.dart';
import 'package:kickoff/features/profile/data/repos/profile_repo.dart';
import 'package:kickoff/features/profile/data/services/profile_service.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';

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
    return BlocProvider(
      create: (context) =>
          ProfileCubit(ProfileRepo(ProfileService(Dio())))..getProfile(),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: SizedBox(
          height: 84.h,
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
                  size: 24,
                ),
                onTap: () => _onItemTapped(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}
