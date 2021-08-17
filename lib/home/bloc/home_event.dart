part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeCheckPermissions extends HomeEvent {
  const HomeCheckPermissions();
}

class HomeLoadMap extends HomeEvent {
  const HomeLoadMap();
}
