import 'package:delivera_flutter/features/rider_actions/data/rider_repository.dart';
import 'package:delivera_flutter/features/rider_actions/logic/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewOrderPage extends ConsumerStatefulWidget {
  const ViewOrderPage({
    super.key,
    required this.order,
    required this.omitTitle,
    required this.onUpdate,
  });
  final Order order;
  final bool omitTitle;
  final Function onUpdate;

  @override
  ConsumerState<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends ConsumerState<ViewOrderPage> {
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd • hh:mm a').format(date);
  }

  _complete() async {
    print("ui complete");
    final result = await ref
        .read(riderRepoProvider)
        .completeOrder(widget.order.id);

    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order picked up successfully!")));
      widget.onUpdate.call();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  _pickup() async {
    print("ui complete");
    final result = await ref
        .read(riderRepoProvider)
        .pickupOrder(widget.order.id);

    if (result == true) {
      widget.onUpdate.call();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order completed successfully!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    print("order status ${widget.order.status}");

    return Scaffold(
      appBar: widget.omitTitle
          ? null
          : AppBar(
              title: const Text('Order Details'),
              centerTitle: true,
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              elevation: 0.5,
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: colorScheme.surface,
          elevation: 2,
          shadowColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID: ${widget.order.id.substring(0, 8)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Chip(
                      label: Text(
                        widget.order.status.name.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _statusColor(
                        widget.order.status,
                        colorScheme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info rows
                // InfoRow(
                //   label: 'Organization ID',
                //   value: widget.order.organizationId.substring(0, 8),
                // ),
                // InfoRow(
                //   label: 'Created By',
                //   value: widget.order.createdById.substring(0, 8),
                // ),
                // InfoRow(
                //   label: 'Rider ID',
                //   value: widget.order.riderId ?? 'Not assigned',
                // ),
                InfoRow(
                  label: 'Rider Session ID',
                  value: widget.order.riderSessionId ?? 'N/A',
                ),

                const Divider(height: 32),

                // Locations
                Text(
                  'Locations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                LocationCard(
                  title: 'Pickup Location',
                  location: widget.order.pickUpLocation,
                ),
                const SizedBox(height: 8),
                LocationCard(
                  title: 'Drop-off Location',
                  location: widget.order.dropOffLocation,
                ),

                const Divider(height: 32),

                // Order details
                Text(
                  'Order Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.order.orderDetails,
                  style: theme.textTheme.bodyMedium,
                ),

                const Divider(height: 14),

                // Date info
                InfoRow(
                  label: 'Created At',
                  value: formatDate(widget.order.createdAt),
                ),
                InfoRow(
                  label: 'Updated At',
                  value: formatDate(widget.order.updatedAt),
                ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // 🔹 Bottom Buttons Section (Apple-grey theme)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 80,
            child: Column(
              children: [
                widget.order.status == OrderStatus.assigned
                    ? Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[350],
                                foregroundColor: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 4,
                              ),
                              onPressed: () {
                                _pickup();
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Pick Up'),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      )
                    : Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[350],
                                foregroundColor: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 4,
                              ),
                              onPressed: () {
                                _complete();
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Complete'),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status, ColorScheme scheme) {
    // Muted greys + subtle accents to stay within your AppTheme
    switch (status) {
      case OrderStatus.created:
        return Colors.grey[400]!;
      case OrderStatus.assigned:
        return Colors.grey[500]!;
      case OrderStatus.delivered:
        return Colors.grey[600]!;
      case OrderStatus.canceled:
        return Colors.grey[700]!;
      default:
        return scheme.primary;
    }
  }
}

//
// 🔹 InfoRow Widget
//
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }
}

//
// 🔹 LocationCard Widget
//
class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required this.title, required this.location});

  final String title;
  final Location location;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      shadowColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(Icons.location_on_outlined, color: colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Lat: ${location.latitude}, Lng: ${location.longitude}',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
      ),
    );
  }
}
