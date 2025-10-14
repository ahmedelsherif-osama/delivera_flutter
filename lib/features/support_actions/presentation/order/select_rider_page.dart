import 'package:delivera_flutter/features/support_actions/data/support_repository.dart';
import 'package:delivera_flutter/features/support_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/support_actions/logic/rider_session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectRiderPage extends ConsumerStatefulWidget {
  const SelectRiderPage({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<SelectRiderPage> createState() => _SelectRiderPageState();
}

class _SelectRiderPageState extends ConsumerState<SelectRiderPage> {
  List<RiderSession>? _riderSessions;
  bool _isFetchingSessions = true;
  String _error = "";
  @override
  initState() {
    super.initState();
    _fetchSessions();
  }

  _fetchSessions() async {
    final result = await ref
        .read(supportRepoProvider)
        .fetchActiveRiderSessions();
    if (result is List<RiderSession>) {
      setState(() {
        _riderSessions = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _isFetchingSessions = false;
    });
  }

  _assignRider(RiderSession riderSession) async {
    final result = await ref
        .read(supportRepoProvider)
        .assignRiderManually(riderSession.riderId!, widget.order.id);
    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Rider assigned successfully!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $result")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Rider'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isFetchingSessions) ...[
              Center(child: CircularProgressIndicator()),
            ] else if (_error != "") ...[
              Center(child: Text(_error)),
            ] else ...[
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search riders...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: _riderSessions!.length,
                  itemBuilder: (context, index) {
                    final riderSession = _riderSessions![index];
                    final riderName = riderSession.riderName != ""
                        ? riderSession.riderName
                        : "R";
                    final status = riderSession.status;
                    final activeOrders = riderSession.activeOrders.length ?? 0;
                    final distance = (index + 1) * 0.8;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Text(riderName![0]),
                        ),
                        title: Text(riderName!),
                        subtitle: Text(
                          '$activeOrders active orders \n${distance.toStringAsFixed(1)} km away',
                        ),
                        trailing: Chip(
                          label: Text(status),
                          backgroundColor: status == 'Working'
                              ? Colors.grey[500]
                              : Colors.grey[300],
                        ),
                        onTap: () {
                          // Confirm selection
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Assign $riderName?'),
                              content: const Text(
                                'Are you sure you want to assign this rider to the order?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _assignRider(riderSession);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
