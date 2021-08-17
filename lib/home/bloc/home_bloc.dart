import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desafio_mobile/home/home.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeCheckPermissions)
      yield* _mapHomeCheckPermissionsToState(event, state);
  }

  Stream<HomeState> _mapHomeCheckPermissionsToState(
      HomeCheckPermissions event, HomeState state) async* {
    yield HomeCheckingPermissions();

    if (!(await _checkStatus())) {
      FirebaseCrashlytics.instance.setCustomKey(
          'home_render_attempt_permission', 'location service denied');
      yield HomePermissionDenied();
    } else {
      yield* _loadMapConfigs();
    }
  }

  Stream<HomeState> _loadMapConfigs() async* {
    try {
      final Location location = Location();
      var locationData = await location.getLocation();
      var coordinates = LatLng(locationData.latitude!, locationData.longitude!);

      await _saveCoordinates(coordinates);
      await _printCoordinates();

      yield HomeShowingMap(coordinates: coordinates);
    } catch (e) {
      FirebaseCrashlytics.instance
          .setCustomKey('home_render_attempt_process', e.toString());
      yield HomeError(e.toString());
    }
  }

  Future<Box<UserModel>> _getBox() async {
    String boxName = FirebaseAuth.instance.currentUser!.uid;
    if (Hive.isBoxOpen(boxName))
      return Hive.box(boxName);
    else
      return await Hive.openBox(boxName);
  }

  _saveCoordinates(LatLng coordinates) async {
    final userModel = UserModel(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
    (await _getBox()).add(userModel);
  }

  _printCoordinates() async {
    final userBox = await _getBox();
    userBox.values.forEach((element) {
      print(element);
    });
  }

  Future<bool> _checkStatus() async {
    final Location location = Location();
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) return await location.requestService();
    return true;
  }
}
