import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:dartz/dartz.dart';
import 'package:delivera_flutter/features/utils/failures/failure.dart';

class LocationService {
  Future<Either<LatLng, Failure>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // 🔹 Try to prompt user to enable it
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          // Some devices don’t return true even after opening settings
          return Right(LocationEnabledFailure());
        }
      }
      print("service $serviceEnabled");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("permission $permission trying again");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          print("permission failed, now failuer $permission");
          return Right(LocationEnabledFailure());
        }
      }

      final position = await Geolocator.getCurrentPosition();
      return Left(LatLng(position.latitude, position.longitude));
    } catch (e) {
      print("Error getting location: $e");
      return Right(LocationEnabledFailure());
    }
  }
}
