import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LaunchMap extends StatefulWidget {
  double lat;
  double lmg;
  LaunchMap({super.key, required this.lat, required this.lmg});

  @override
  State<LaunchMap> createState() => _LaunchMapState();
}

class _LaunchMapState extends State<LaunchMap> {
  late double lat1;
  late double lng1;

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(31.520737147957025, 74.32255994211431), zoom: 15);
// 31.520737147957025, 74.32255994211431

  List<Marker> _marker = [];
  List<Marker> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(initialCameraPosition: _kGooglePlex),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      lat1 = widget.lat;
      lng1 = widget.lmg;
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat1, lng1),
        zoom: 20,
      );
    }).onError((error, stackTrace) {
      print("erron" + error.toString());
    });
  }
}
