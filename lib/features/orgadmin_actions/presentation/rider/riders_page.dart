import 'package:accordion/accordion.dart';
import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/rider_session_model.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/rider_summary_response.dart';
import 'package:delivera_flutter/features/orgadmin_actions/presentation/rider/rider_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class RidersPage extends ConsumerStatefulWidget {
  const RidersPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<RidersPage> createState() => _RidersPageState();
}

class _RidersPageState extends ConsumerState<RidersPage> {
  String? selectedCategory;
  String? selectedRider;
  bool isActiveRider = false;

  final riderStats = {'offline': 100, 'active': 20, 'onBreak': 10};
  final riders = {
    'offline': List.generate(30, (i) => 'Offline Rider ${i + 1}'),
    'active': List.generate(12, (i) => 'Active Rider ${i + 1}'),
    'onBreak': List.generate(8, (i) => 'OnBreak Rider ${i + 1}'),
  };

  List<RiderSession>? _activeRiderSessions;
  List<RiderSession>? _onBreakRiderSessions;
  List<RiderUser>? _offlineRiders;
  bool _isFetchingRiders = true;
  String _error = "";

  Timer? updateTimer;

  _fetchAllRiders() async {
    final result = await ref.read(orgAdminRepoProvider).fetchAllRiders();
    if (result is RiderSummaryResponse) {
      setState(() {
        _activeRiderSessions = result.activeRiderSessions;
        _onBreakRiderSessions = result.onBreakRiderSessions;
        _offlineRiders = result.offlineRiders;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _isFetchingRiders = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllRiders();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  void _onRiderSelect(String category, String riderName) {
    setState(() {
      selectedCategory = category;
      selectedRider = riderName;
      isActiveRider = category == 'active';
    });

    if (isActiveRider) {
      updateTimer?.cancel();
      updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        setState(() {
          // TODO: refresh location here
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        widget.onBack.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              // 🧾 Summary Header
              //
              Center(
                child: Text(
                  "Rider Summary",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              if (_isFetchingRiders) ...[
                Center(child: CircularProgressIndicator()),
              ] else if (_error != "") ...[
                Center(child: Text(_error)),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(
                      label: 'Offline',
                      value: _offlineRiders!.length,
                      categoryKey: "offline",
                      onTap: (categoryKey) {
                        setState(() {
                          selectedCategory = categoryKey;
                        });
                      },
                    ),
                    _StatCard(
                      label: 'Active',
                      value: _activeRiderSessions!.length,
                      categoryKey: "active",
                      onTap: (categoryKey) {
                        setState(() {
                          selectedCategory = categoryKey;
                        });
                      },
                    ),
                    _StatCard(
                      label: 'On Break',
                      value: _onBreakRiderSessions!.length,
                      categoryKey: "onBreak",
                      onTap: (categoryKey) {
                        setState(() {
                          selectedCategory = categoryKey;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  height: 370,
                  child: Accordion(
                    maxOpenSections: 1, // only one open
                    headerBackgroundColor: Colors.white70,
                    headerBorderWidth: 1,
                    headerBorderColor: Colors.grey.shade200,
                    headerBorderColorOpened: Colors.grey.shade400,
                    headerBackgroundColorOpened: Theme.of(
                      context,
                    ).scaffoldBackgroundColor,
                    headerPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    contentBorderColor: Colors.grey.shade200,
                    contentBackgroundColor: Colors.grey.shade50,
                    rightIcon: const Icon(Icons.keyboard_arrow_down, size: 22),
                    openAndCloseAnimation: true,
                    disableScrolling: true,
                    children: [
                      // Active Riders
                      AccordionSection(
                        isOpen: selectedCategory == "active",
                        header: const Text(
                          'Active Riders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // content: use a bounded container with an internal ListView
                        content: _buildScrollableRiderList(
                          categoryKey: 'active',
                          sessions: _activeRiderSessions,
                          type: "sessions",
                        ),
                      ),

                      // On Break Riders
                      AccordionSection(
                        isOpen: selectedCategory == "onBreak",
                        header: const Text(
                          'On Break Riders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: _buildScrollableRiderList(
                          categoryKey: 'onBreak',
                          sessions: _onBreakRiderSessions,
                          type: "sessions",
                        ),
                      ),

                      // Offline Riders
                      AccordionSection(
                        isOpen: selectedCategory == "offline",
                        header: const Text(
                          'Offline Riders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: _buildScrollableRiderList(
                          categoryKey: 'offline',

                          riders: _offlineRiders,
                          type: "riders",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                //
                // 👤 Rider Detail Section
                //
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Build a vertically scrollable list for a category.
  // The container has a max height so it won't overflow the overall accordion area.
  Widget _buildScrollableRiderList({
    required String categoryKey,
    List<RiderSession>? sessions,
    List<RiderUser>? riders,
    required String type,
  }) {
    // Choose an appropriate max height for the inner list. If the accordion has limited space
    // (here accordion area is 370), giving the inner list a computed max keeps UX consistent.
    const double maxContentHeight = 250;
    final list = sessions ?? riders;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: maxContentHeight),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list!.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final rider = list[index];
          final riderName = rider is RiderUser
              ? "${rider.firstName} ${rider.lastName}"
              : rider is RiderSession
              ? "${rider.riderName}"
              : "";
          final isSelected = selectedRider == rider;
          IconData leadingIcon;
          Color? iconColor;
          switch (categoryKey) {
            case 'active':
              leadingIcon = Icons.directions_bike;
              iconColor = Colors.green;
              break;
            case 'onBreak':
              leadingIcon = Icons.pause_circle;
              iconColor = Colors.orange;
              break;
            default:
              leadingIcon = Icons.wifi_off;
              iconColor = Colors.red;
          }

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(riderName),
            leading: Icon(leadingIcon, color: iconColor),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RiderDetailPage(
                  category: categoryKey,
                  rider: rider is RiderUser ? rider : null,
                  riderSession: rider is RiderSession ? rider : null,
                ),
              ),
            ),
            tileColor: isSelected ? iconColor!.withOpacity(0.08) : null,
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Colors.black54)
                : null,
          );
        },
      ),
    );
  }
}

//
// 🔹 Summary Stat Card
//
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Function(String categoryKey) onTap;
  final String categoryKey;
  const _StatCard({
    required this.label,
    required this.value,
    required this.onTap,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(categoryKey).call();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Tapped bro!")));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔹 Active Rider Detail Section — uses flutter_map
//

//
// 🔹 Inactive Rider Detail Section
//
