import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewOrderPage extends StatelessWidget {
  const ViewOrderPage({super.key, required this.order});
  final Order order;

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd • hh:mm a').format(date);
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
                      'Order ID: ${order.id.substring(0, 8)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Chip(
                      label: Text(
                        order.status.name.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _statusColor(order.status, colorScheme),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info rows
                InfoRow(
                  label: 'Organization ID',
                  value: order.organizationId.substring(0, 8),
                ),
                InfoRow(
                  label: 'Created By',
                  value: order.createdById.substring(0, 8),
                ),
                InfoRow(
                  label: 'Rider ID',
                  value: order.riderId ?? 'Not assigned',
                ),
                InfoRow(
                  label: 'Rider Session ID',
                  value: order.riderSessionId ?? 'N/A',
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
                  location: order.pickUpLocation,
                ),
                const SizedBox(height: 8),
                LocationCard(
                  title: 'Drop-off Location',
                  location: order.dropOffLocation,
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
                Text(order.orderDetails, style: theme.textTheme.bodyMedium),

                const Divider(height: 32),

                // Date info
                InfoRow(
                  label: 'Created At',
                  value: formatDate(order.createdAt),
                ),
                InfoRow(
                  label: 'Updated At',
                  value: formatDate(order.updatedAt),
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
                    // TODO: Handle dispatch logic
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
                    // TODO: Handle complete logic
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
                    // TODO: Handle cancel logic
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
