import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/register_view.dart';
import 'package:kickoff/features/onboarding/onboarding_screen.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
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
