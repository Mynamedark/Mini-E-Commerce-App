import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../l10n/app_localizations.dart';

class NearbyStoresMap extends StatefulWidget {
  const NearbyStoresMap({super.key});

  @override
  State<NearbyStoresMap> createState() => _NearbyStoresMapState();
}

class _NearbyStoresMapState extends State<NearbyStoresMap> {
  LatLng? _currentPos;
  bool _loading = true;

  // Sample nearby stores
  final List<LatLng> _nearbyStores = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPos = LatLng(pos.latitude, pos.longitude);
      _loading = false;

      // Generate sample nearby stores (demo)
      _nearbyStores.addAll([
        LatLng(pos.latitude + 0.001, pos.longitude + 0.001),
        LatLng(pos.latitude - 0.0015, pos.longitude - 0.001),
        LatLng(pos.latitude + 0.002, pos.longitude - 0.0015),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context); // Localization

    return Scaffold(
      appBar: AppBar(title: Text(t.t('nearby_stores'))),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _currentPos == null
          ? Center(child: Text(t.t('location_permission_denied')))
          : FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: _currentPos!,
          initialZoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPos!,
                width: 40,
                height: 40,
                // anchor: Anchor.center,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 36,
                ),
              ),
              ..._nearbyStores.map(
                    (store) => Marker(
                  point: store,
                  width: 40,
                  height: 40,
                  // anchor: Anchor.center,
                  child: const Icon(
                    Icons.store,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
