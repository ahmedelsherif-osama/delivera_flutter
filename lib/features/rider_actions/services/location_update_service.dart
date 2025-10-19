import 'dart:async';
import 'dart:convert';
import 'package:delivera_flutter/features/authentication/data/token_storage.dart';
import 'package:delivera_flutter/features/utils/failures/failure.dart';
import 'package:delivera_flutter/features/utils/location_service/location_service.dart';

import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/authentication/logic/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔹 Background location updater service
class LocationUpdateService with WidgetsBindingObserver {
  final Ref ref;

  LocationUpdateService(this.ref);

  final _locationService = LocationService();
  final _credentialsService = TokenStorage();
  Timer? _updateTimer;
  bool _isRunning = false;

  /// Start location updates if user is a rider
  Future<void> start() async {
    print("start called");
    if (_isRunning) return;
    print("location service isnt running yet");
    final user = ref.read(userProvider);
    final role = user?.organizationRole;

    if (role == null || role.toLowerCase() != 'rider') {
      print("🟡 User is not a rider → location updates disabled.");
      return;
    }

    print("✅ Starting background location updates for rider...");
    WidgetsBinding.instance.addObserver(this);
    _schedulePeriodicUpdates();
    _isRunning = true;
  }

  void stop() {
    print("🛑 Stopping background location updates...");
    WidgetsBinding.instance.removeObserver(this);
    _updateTimer?.cancel();
    _isRunning = false;
  }

  void _schedulePeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _updateRiderLocation();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("🔄 App resumed → restarting location updates.");
      _schedulePeriodicUpdates();
    } else if (state == AppLifecycleState.paused) {
      print("⏸️ App paused → optionally pause updates.");
      // Optionally stop or throttle updates here
    }
  }

  Future<void> _updateRiderLocation() async {
    print("📍 Attempting to update rider location...");
    final locationResult = await _locationService.getCurrentLocation();

    locationResult.fold((latLng) async {
      print("✅ Got location: ${latLng.latitude}, ${latLng.longitude}");
      await _sendLocationToServer(latLng);
    }, (failure) => print("⚠️ Failed to get location: $failure"));
  }

  Future<void> _sendLocationToServer(LatLng latLng) async {
    try {
      final token = await _credentialsService.getAccessToken();
      if (token == null) {
        print("⚠️ No token found, cannot send location.");
        return;
      }

      final url = Uri.parse(
        "http://localhost:5208/api/ridersessions/updateriderlocation/",
      );
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Location updated successfully!");
      } else {
        print(
          "❌ Failed to update location: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("🚨 Error sending location: $e");
    }
  }
}

final locationUpdateServiceProvider = Provider<LocationUpdateService>((ref) {
  return LocationUpdateService(ref);
});
