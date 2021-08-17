part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeCheckingPermissions extends HomeState {}

class HomePermissionDenied extends HomeState {}

class HomeError extends HomeState {
  final String errorMessage;
  const HomeError(this.errorMessage);
}

class HomeShowingMap extends HomeState {
  final LatLng coordinates;

  const HomeShowingMap({required this.coordinates});
}
