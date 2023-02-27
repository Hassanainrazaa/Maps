import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Marker> _maker = [];
  List<Marker> _list = const [];

  Completer<GoogleMapController> _controller = Completer();

  loadData() {
    getUserLocation().then((value) async {
      print("My current location");
      print(value.latitude.toString() + value.longitude.toString());
      _maker.add(Marker(
          markerId: MarkerId("1"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: "this title of info windows")));

      CameraPosition cameraPosition = CameraPosition(
          zoom: 20, target: LatLng(value.latitude, value.longitude));

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("erron" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  static final CameraPosition _KGoogleFlex =
      CameraPosition(target: LatLng(31.520310, 74.325111), zoom: 14.4746);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
            mapType: MapType.normal,
            markers: Set<Marker>.of(_maker),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: _KGoogleFlex),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_disabled_outlined),
        onPressed: () async {
          getUserLocation().then((value) async {
            print("My current location");
            print(value.latitude.toString() + value.longitude.toString());
            _maker.add(Marker(
                markerId: MarkerId("1"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(title: "this title of info windows")));

            CameraPosition cameraPosition = CameraPosition(
                zoom: 20, target: LatLng(value.latitude, value.longitude));

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
      ),
    );
  }
}
