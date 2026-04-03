import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/login_view_view.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/register_view.dart';
import 'package:kickoff/features/home/home_view.dart';
import 'package:kickoff/features/onboarding/onboarding_screen.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/all_stadiums_screen.dart';
import 'package:kickoff/features/stadiums/presentation/ui/stadium_details_screen.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());

      case Routes.stadiumDetails:
        final stadium = settings.arguments as StadiumModel;
        return MaterialPageRoute(
          builder: (_) => StadiumDetailsScreen(stadium: stadium),
        );

      case Routes.stadiumsAll:
        final stadiums = settings.arguments as List<StadiumModel>;
        return MaterialPageRoute(
          builder: (_) => AllStadiumsScreen(stadiums: stadiums),
        );
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LogginView());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}
