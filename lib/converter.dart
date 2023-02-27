import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_geocoder/geocoder.dart';

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  State<Converter> createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  String stAddress = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAddress),
          InkResponse(
            onTap: () async {
              final query =
                  "Wahdat Rd, Muslim Town, Lahore, Punjab 54000, Pakistan";
              var addresses =
                  await Geocoder.local.findAddressesFromQuery(query);
              var second = addresses.first;
              print("${second.featureName} : ${second.coordinates}");

              final coordinates = Coordinates(31.520310, 74.325111);
              var address = await Geocoder.local
                  .findAddressesFromCoordinates(coordinates);
              var first = address.first;

              print(
                  first.featureName.toString() + first.addressLine.toString());

              setState(() {
                stAddress = first.featureName.toString() +
                    " " +
                    first.addressLine.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.green),
                child: Center(
                  child: Text("Converter"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
