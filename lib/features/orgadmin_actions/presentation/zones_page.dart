import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/presentation/create_zone_page.dart';
import 'package:delivera_flutter/features/orgadmin_actions/presentation/view_zone_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/zone_model.dart';

class ZonesPage extends ConsumerStatefulWidget {
  const ZonesPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<ZonesPage> createState() => _ZonesPageState();
}

class _ZonesPageState extends ConsumerState<ZonesPage> {
  List<Zone> _zones = [];
  bool _fetchingZones = true;
  String _error = "";

  _fetchZones() async {
    final result = await ref.read(orgAdminRepoProvider).fetchZones();

    if (result is List<Zone>) {
      setState(() {
        _zones = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _fetchingZones = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchZones();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        widget.onBack.call();
      },
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Zones",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 10),

                if (_fetchingZones) ...[
                  Center(child: CircularProgressIndicator()),
                ] else if (_error != "") ...[
                  Center(child: Text(_error)),
                ] else ...[
                  SizedBox(
                    height: 400,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 60,
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Name")),
                        ],
                        rows: _zones
                            .map(
                              (zone) => DataRow(
                                cells: [
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewZonePage(zone: zone),
                                          ),
                                        );
                                        // setState(() {
                                        //   _selectedZone = zone;
                                        //   _viewSingleZone = true;
                                        // });
                                      },
                                      child: Container(
                                        child: Text(zone.id.substring(0, 8)),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewZonePage(zone: zone),
                                          ),
                                        );
                                        // setState(() {
                                        //   _selectedZone = zone;
                                        //   _viewSingleZone = true;
                                        // });
                                      },
                                      child: Container(child: Text(zone.name)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateZonePage(
                    onSuccess: (zone) {
                      setState(() {
                        _zones.add(zone);
                      });
                    },
                  ),
                ),
              );
            },
            child: Text("Add Zone"),
          ),
        ],
      ),
    );
  }
}
