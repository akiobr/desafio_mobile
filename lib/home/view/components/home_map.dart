import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMap extends StatelessWidget {
  final LatLng coordinates;

  const HomeMap({
    Key? key,
    required this.coordinates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: {
        Marker(markerId: MarkerId('init'), position: coordinates),
      },
      initialCameraPosition: CameraPosition(
        target: coordinates,
        zoom: 15.0,
      ),
      onMapCreated: (c) {
        var user = FirebaseAuth.instance.currentUser!;

        FirebaseAnalytics().logEvent(
          name: 'map_rendered',
          parameters: {
            'uid': user.uid,
            'email': user.email,
            'latitude': coordinates.latitude,
            'logitude': coordinates.longitude,
          },
        );
      },
    );
  }
}
