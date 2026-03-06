import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

abstract class StadiumsState {}

class StadiumsInitial extends StadiumsState {}

class StadiumsLoading extends StadiumsState {}

class StadiumsSuccess extends StadiumsState {
  final List<StadiumModel> stadiums;

  StadiumsSuccess(this.stadiums);
}

class StadiumsFailure extends StadiumsState {
  final String error;

  StadiumsFailure(this.error);
}
