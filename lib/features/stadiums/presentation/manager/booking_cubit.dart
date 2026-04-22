import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/stadiums/data/models/slots_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {
  final List<TimeSlot> selectedSlots;
  BookingInitial({this.selectedSlots = const []});
}

class BookingUpdated extends BookingState {
  final List<TimeSlot> selectedSlots;
  BookingUpdated({required this.selectedSlots});
}

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  List<TimeSlot> _selectedSlots = [];

  List<TimeSlot> get selectedSlots => _selectedSlots;

  void toggleSlot(TimeSlot slot) {
    if (_selectedSlots.contains(slot)) {
      _selectedSlots.remove(slot);
    } else {
      _selectedSlots.add(slot);
    }
    emit(BookingUpdated(selectedSlots: List.from(_selectedSlots)));
  }

  void clearSlots() {
    _selectedSlots.clear();
    emit(BookingUpdated(selectedSlots: []));
  }

  bool get canConfirm => _selectedSlots.length >= 2;
}
