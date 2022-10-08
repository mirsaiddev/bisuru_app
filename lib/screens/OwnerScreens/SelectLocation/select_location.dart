import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key, this.initialPosition}) : super(key: key);

  final LatLng? initialPosition;

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  GoogleMapController? controller;

  static CameraPosition initialLocation = CameraPosition(target: LatLng(38.6748, 39.2225), zoom: 14.4746);
  Set<Marker> markers = {};
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() async {
    await Permission.location.request();
    if (widget.initialPosition != null) {
      initialLocation = CameraPosition(target: widget.initialPosition!, zoom: 14.4746);
      selectedLocation = widget.initialPosition;
      markers.add(Marker(markerId: MarkerId('${selectedLocation!.latitude}'), position: selectedLocation!));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
          child: MyButton(
            text: 'Seç',
            onPressed: selectedLocation != null
                ? () {
                    Navigator.pop(context, selectedLocation);
                  }
                : null,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(
                title: 'Lokasyon Seç',
                showBackButton: true,
              ),
              SizedBox(height: 10),
              Expanded(
                child: MyListTile(
                  padding: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GoogleMap(
                      initialCameraPosition: initialLocation,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController _controller) async {
                        controller = _controller;
                        controller!.setMapStyle(await rootBundle.loadString('lib/assets/txt/map_style.txt'));
                      },
                      markers: markers,
                      onTap: (position) {
                        if (controller != null) {
                          controller!
                              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));
                        }
                        markers.clear();
                        markers.add(Marker(markerId: MarkerId('${position.latitude}'), position: LatLng(position.latitude, position.longitude)));
                        selectedLocation = position;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
