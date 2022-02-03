import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  static const String routeName = 'home';

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late MapboxMapController mapController;
  final LatLng center = const LatLng(37.810575, -122.477174);

  final black = 'mapbox://styles/brandon-rs/ckz77mzol000j14n28216uzvz';
  final white = 'mapbox://styles/brandon-rs/ckz77reh3002414mm5niomtht';
  String selectedStyle = 'mapbox://styles/brandon-rs/ckz77mzol000j14n28216uzvz';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _inclination();
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  void _inclination() {
    mapController.animateCamera(CameraUpdate.tiltTo(40));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMap(),
      floatingActionButton: _floatingBottons(),
    );
  }

  Column _floatingBottons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Simbols
        FloatingActionButton(
          child: const Icon(Icons.sentiment_satisfied),
          onPressed: () {
            mapController.addSymbol(
              SymbolOptions(
                geometry: center,
                // iconImage: 'networkImage',
                iconImage: 'assetImage',
                iconColor: '#fff',
                iconSize: 3,
                textField: 'Start point',
                textColor: '#fff',
                textOffset: const Offset(0, 2),
              ),
            );
          },
        ),
        const SizedBox(height: 5),

        // Zoom In
        FloatingActionButton(
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomIn(),
              // CameraUpdate.tiltTo(40),
            );
          },
        ),
        const SizedBox(height: 5),

        // Zoom Out
        FloatingActionButton(
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomOut(),
            );
          },
        ),
        const SizedBox(height: 5),

        // Change Style
        FloatingActionButton(
          child: const Icon(Icons.add_to_home_screen),
          onPressed: () {
            selectedStyle = selectedStyle == black ? white : black;
            setState(() {});
          },
        ),
      ],
    );
  }

  MapboxMap buildMap() {
    return MapboxMap(
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 10,
      ),
    );
  }
}
