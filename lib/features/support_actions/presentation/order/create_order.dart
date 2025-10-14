import 'package:delivera_flutter/features/support_actions/data/support_repository.dart';
import 'package:delivera_flutter/features/support_actions/logic/order_model.dart'
    show Order, Location, OrderStatus;
import 'package:delivera_flutter/features/support_actions/presentation/shared/location_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class CreateOrder extends ConsumerStatefulWidget {
  const CreateOrder({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  ConsumerState<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends ConsumerState<CreateOrder> {
  final _orderDetailsController = TextEditingController();
  final _pickUpLocationDetails = TextEditingController();
  final _dropOffLocationDetails = TextEditingController();

  Location? _pickUpLocation;
  Location? _dropOffLocation;
  LatLng? _pickUpCoords;
  LatLng? _dropOffCoords;

  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  Future<void> _createOrder() async {
    print("inside create");
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_pickUpCoords == null || _dropOffCoords == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both locations")),
      );
      return;
    }
    print("crossed checks");

    setState(() => _submitting = true);

    final order = Order(
      id: "",
      organizationId: "",
      status: OrderStatus.created,
      pickUpLocation: Location(
        latitude: _pickUpCoords!.latitude,
        longitude: _pickUpCoords!.longitude,
        address: _pickUpLocationDetails.text,
        timestamp: DateTime.now(),
      ),
      dropOffLocation: Location(
        latitude: _dropOffCoords!.latitude,
        longitude: _dropOffCoords!.longitude,
        address: _dropOffLocationDetails.text,
        timestamp: DateTime.now(),
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      orderDetails: _orderDetailsController.text,
      createdById: "",
    );

    final result = await ref.read(supportRepoProvider).createOrder(order);
    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order created!")));
      widget.onBack.call();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $result")));
    }
    setState(() => _submitting = false);
  }

  Future<void> _selectLocation(bool isPickup) async {
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (_) => const SelectLocationPage()),
    );

    if (result != null) {
      setState(() {
        if (isPickup) {
          _pickUpCoords = result;
        } else {
          _dropOffCoords = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Create Order", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Order Details",
                border: OutlineInputBorder(),
              ),
              controller: _orderDetailsController,
              validator: (value) =>
                  (value == null || value.isEmpty) ? "Required" : null,
            ),
            const SizedBox(height: 20),

            LocationSection(
              label: "Pickup Location",
              controller: _pickUpLocationDetails,
              coords: _pickUpCoords,
              onSelect: () => _selectLocation(true),
            ),
            const SizedBox(height: 20),

            LocationSection(
              label: "Dropoff Location",
              controller: _dropOffLocationDetails,
              coords: _dropOffCoords,
              onSelect: () => _selectLocation(false),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _createOrder,
                child: _submitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  const LocationSection({
    super.key,
    required this.label,
    required this.controller,
    required this.onSelect,
    this.coords,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onSelect;
  final LatLng? coords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "$label Details",
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Required" : null,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: onSelect, child: const Text("Select")),
          ],
        ),
        if (coords != null) ...[
          const SizedBox(height: 6),
          Text(
            "Lat: ${coords!.latitude.toStringAsFixed(5)}, Lng: ${coords!.longitude.toStringAsFixed(5)}",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ],
    );
  }
}
