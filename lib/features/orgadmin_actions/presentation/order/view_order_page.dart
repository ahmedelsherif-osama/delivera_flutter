import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewOrderPage extends ConsumerStatefulWidget {
  const ViewOrderPage({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends ConsumerState<ViewOrderPage> {
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd • hh:mm a').format(date);
  }

  _autoDispatch() async {
    final result = await ref
        .read(orgAdminRepoProvider)
        .autoAssignOrder(widget.order.id);

    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order dispatched successfully!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  _complete() async {
    print("ui complete");
    final result = await ref
        .read(orgAdminRepoProvider)
        .completeOrder(widget.order.id);

    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order completed successfully!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  _cancel() async {
    final result = await ref
        .read(orgAdminRepoProvider)
        .cancelOrder(widget.order.id);

    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order canceled successfully!")));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
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
                InfoRow(
                  label: 'Organization ID',
                  value: widget.order.organizationId.substring(0, 8),
                ),
                InfoRow(
                  label: 'Created By',
                  value: widget.order.createdById.substring(0, 8),
                ),
                InfoRow(
                  label: 'Rider ID',
                  value: widget.order.riderId ?? 'Not assigned',
                ),
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

                const Divider(height: 32),

                // Date info
                InfoRow(
                  label: 'Created At',
                  value: formatDate(widget.order.createdAt),
                ),
                InfoRow(
                  label: 'Updated At',
                  value: formatDate(widget.order.updatedAt),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

      // 🔹 Bottom Buttons Section (Apple-grey theme)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Dispatch Options',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.auto_awesome_outlined),
                                label: const Text('Auto-Dispatch'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[400],
                                  foregroundColor: Colors.grey[900],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () async {
                                  await _autoDispatch();
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.person_search_outlined),
                                label: const Text('Manual Dispatch'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor: Colors.grey[900],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // TODO: Navigate to rider-selection screen
                                },
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: const Text('Dispatch'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[350],
                    foregroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                  ),
                  onPressed: () {
                    _cancel();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel'),
                ),
              ),
            ],
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
