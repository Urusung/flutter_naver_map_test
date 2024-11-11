import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final currentPositionProvider = FutureProvider<Position>((ref) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location permissions are permanently denied.");
  }
  return await Geolocator.getCurrentPosition();
});
