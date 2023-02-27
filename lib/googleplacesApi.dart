import 'dart:convert';

import 'package:chatapp/Launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GooglePlacesAPIScreen extends StatefulWidget {
  const GooglePlacesAPIScreen({super.key});

  @override
  State<GooglePlacesAPIScreen> createState() => _GooglePlacesAPIScreenState();
}

class _GooglePlacesAPIScreenState extends State<GooglePlacesAPIScreen> {
  TextEditingController controller = TextEditingController();
  String _sessionToken = "12345";
  var uuid = Uuid();
  List<dynamic> _placesList = [];

  onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSegguestion(controller.text);
  }

  getSegguestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDcgdyfpAr-5TR0XUhgP4GJ2xQEoN4lm-8";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var responce = await http.get(Uri.parse(request));
    var data = responce.body.toString();

    print(responce.body.toString());
    if (responce.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(responce.body.toString())['predictions'];
      });
    } else {
      throw Exception("Failed to Load a data");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Google Maps Place Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search Place with name",
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _placesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              _placesList[index]['description']);

                          print(locations.last.latitude);
                          print(locations.last.longitude);
                          //print(_placesList[index]['latitude']);

                          if (locations.isNotEmpty) {
                            double lat = locations.last.latitude;
                            double lng = locations.last.longitude;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LaunchMap(
                                        lat: lat,
                                        lmg: lng,
                                      )),
                            );
                          } else {
                            print("naaaaaaaaaaan");
                          }

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => LaunchMap()),
                          // );
                        },
                        title: Text(_placesList[index]['description']),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
