import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';

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
  bool _viewSingleZone = false;
  Zone? _selectedZone;

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
        if (_viewSingleZone) {
          setState(() {
            _viewSingleZone = false;
          });
        } else {
          widget.onBack.call();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "Zones",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 10),
            if (_viewSingleZone) ...[
              ViewZonePage(zone: _selectedZone!),
            ] else ...[
              if (_fetchingZones) ...[
                Center(child: CircularProgressIndicator()),
              ] else if (_error != "") ...[
                Center(child: Text(_error)),
              ] else ...[
                SizedBox(
                  height: 518,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 30,
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
                                      setState(() {
                                        _selectedZone = zone;
                                        _viewSingleZone = true;
                                      });
                                    },
                                    child: Container(
                                      child: Text(zone.id.substring(0, 8)),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedZone = zone;
                                        _viewSingleZone = true;
                                      });
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
          ],
        ),
      ),
    );
  }
}

class ViewZonePage extends StatefulWidget {
  const ViewZonePage({super.key, required this.zone});
  final Zone zone;

  @override
  State<ViewZonePage> createState() => _ViewZonePageState();
}

class _ViewZonePageState extends State<ViewZonePage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("View Single Zone"));
  }
}
