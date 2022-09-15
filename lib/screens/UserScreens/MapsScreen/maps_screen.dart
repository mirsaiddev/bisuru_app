import 'dart:typed_data';

import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? controller;

  static final CameraPosition initialLocation = CameraPosition(target: LatLng(38.6748, 39.2225), zoom: 13.5);
  Set<Marker> markers = {};
  LatLng? selectedLocation;
  BitmapDescriptor? markerIcon;
  OwnerModel? selectedOwner;

  Future<void> setMarkers() async {
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    placesProvider.places.forEach((place) {
      markers.add(Marker(
        markerId: MarkerId(place.uid!),
        position: LatLng(place.placeAddress!['lat'], place.placeAddress!['long']),
        icon: markerIcon!,
        onTap: () {
          if (controller != null) {
            controller!.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(place.placeAddress!['lat'], place.placeAddress!['long']), zoom: 14)));
          }
          setState(() {
            selectedOwner = place;
          });
        },
      ));
    });
    setState(() {});
  }

  Future<void> setMarkerIcon() async {
    final Uint8List uint8listGrey = await getBytesFromAsset('lib/assets/images/pin.png');
    markerIcon = await BitmapDescriptor.fromBytes(uint8listGrey);
  }

  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: pixelRatio.round() * 40);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: MyListTile(
                  padding: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GoogleMap(
                          myLocationButtonEnabled: false,
                          initialCameraPosition: initialLocation,
                          onMapCreated: (GoogleMapController _controller) async {
                            controller = _controller;
                            controller!.setMapStyle(await rootBundle.loadString('lib/assets/txt/map_style.txt'));
                            await setMarkerIcon();
                            await setMarkers();
                          },
                          markers: markers,
                        ),
                        if (selectedOwner != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: 250,
                              child: PlaceWidget(ownerModel: selectedOwner!),
                            ),
                          ),
                      ],
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
