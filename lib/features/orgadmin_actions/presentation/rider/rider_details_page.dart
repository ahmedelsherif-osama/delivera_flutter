import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/rider_session_model.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/rider_summary_response.dart';
import 'package:delivera_flutter/features/orgadmin_actions/presentation/rider/order_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class RiderDetailPage extends ConsumerStatefulWidget {
  final String category;
  final RiderSession? riderSession;
  final RiderUser? rider;
  const RiderDetailPage({
    super.key,
    required this.category,
    this.riderSession,
    this.rider,
  });

  @override
  ConsumerState<RiderDetailPage> createState() => _RiderDetailPageState();
}

class _RiderDetailPageState extends ConsumerState<RiderDetailPage> {
  List<Order>? _orders;
  bool _isFetchingOrders = true;
  String _error = "";

  @override
  initState() {
    super.initState();
    _fetchOrders();
  }

  _fetchOrders() async {
    final riderId = widget.category == "offline"
        ? widget.rider!.id
        : widget.riderSession!.riderId;
    final result = await ref
        .read(orgAdminRepoProvider)
        .fetchRiderOrders(riderId!);
    if (result is List<Order>) {
      setState(() {
        _orders = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _isFetchingOrders = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.category != 'offline';
    final riderName = isActive
        ? widget.riderSession!.riderName
        : "${widget.rider!.firstName} ${widget.rider!.lastName}";

    if (_isFetchingOrders) {
      return Center(child: CircularProgressIndicator());
    } else if (_error != "") {
      return Center(child: Text(_error));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(riderName!),
        backgroundColor: isActive ? Colors.green : Colors.grey.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isActive
            ? _ActiveRiderDetails(
                riderSession: widget.riderSession!,
                orders: _orders!,
              )
            : _InactiveRiderDetails(rider: widget.rider!, orders: _orders!),
      ),
    );
  }
}

class _ActiveRiderDetails extends StatelessWidget {
  final RiderSession riderSession;
  final List<Order> orders;
  _ActiveRiderDetails({required this.riderSession, required this.orders});
  final apiKey = dotenv.env['MAPTILER_API_KEY'];

  @override
  Widget build(BuildContext context) {
    final riderLocation = LatLng(riderSession.latitude, riderSession.longitude);
    final pickupLocation = riderSession.currentOrderPickUp;
    final dropoffLocation = riderSession.currentOrderDropOff;
    final currentOrderId =
        (riderSession.currentOrderId != null &&
            riderSession.currentOrderId != "")
        ? riderSession.currentOrderId!.substring(0, 8)
        : "No order";
    final status = riderSession.currentOrderId != null
        ? "En Route"
        : "Ready for orders";

    final markers = <Marker>[
      Marker(
        point: riderLocation,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.person_pin_circle,
          color: Colors.green,
          size: 32,
        ),
      ),
    ];

    if (pickupLocation != null && dropoffLocation != null) {
      markers.addAll([
        Marker(
          point: LatLng(pickupLocation.latitude, pickupLocation.longitude),
          width: 40,
          height: 40,
          child: const Icon(Icons.storefront, color: Colors.blue, size: 30),
        ),
        Marker(
          point: LatLng(dropoffLocation.latitude, dropoffLocation.longitude),
          width: 40,
          height: 40,
          child: const Icon(Icons.flag, color: Colors.red, size: 30),
        ),
      ]);
    }

    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                riderSession.riderName!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Active Order: $currentOrderId'),
              const SizedBox(height: 8),
              Text('Current Order Status: $status'),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: riderLocation,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$apiKey',
                        userAgentPackageName: 'com.example.delivera_flutter',
                      ),
                      MarkerLayer(markers: markers),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OrderHistoryWidget(orders: orders),
            ],
          ),
        ),
      ),
    );
  }
}

class _InactiveRiderDetails extends StatelessWidget {
  final RiderUser rider;
  final List<Order> orders;

  const _InactiveRiderDetails({required this.rider, required this.orders});

  @override
  Widget build(BuildContext context) {
    final riderName = "${rider.firstName} ${rider.lastName}";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              riderName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            OrderHistoryWidget(orders: orders),
          ],
        ),
      ),
    );
  }
}
