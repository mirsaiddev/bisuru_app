import 'dart:typed_data';

import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:bi_suru_app/widgets/place_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key, this.ownerModel}) : super(key: key);

  final OwnerModel? ownerModel;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? controller;

  CameraPosition? initialLocation;
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
        flat: true,
        icon: markerIcon!,
        draggable: true,
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

  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  LocationData? userLocation;

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    if (widget.ownerModel != null) {
      selectedOwner = widget.ownerModel;
      initialLocation = CameraPosition(target: LatLng(selectedOwner!.placeAddress!['lat'], selectedOwner!.placeAddress!['long']), zoom: 14);
      setState(() {});
      return;
    }
    Location location = Location();

    initialLocation = initialLocation = CameraPosition(target: LatLng(38.6748, 39.2225), zoom: 13.5);
    try {
      // Check if location service is enable
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          initialLocation = initialLocation = CameraPosition(target: LatLng(38.6748, 39.2225), zoom: 13.5);
          return;
        }
      }

      // Check if permission is granted
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          initialLocation = initialLocation = CameraPosition(target: LatLng(38.6748, 39.2225), zoom: 13.5);
          return;
        }
      }

      final _locationData = await location.getLocation();
      setState(() {
        userLocation = _locationData;
        initialLocation = CameraPosition(target: LatLng(userLocation!.latitude!, userLocation!.longitude!), zoom: 13.5);
      });
    } catch (e) {
      initialLocation = initialLocation = CameraPosition(target: LatLng(38.6748, 39.2225), zoom: 13.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Builder(builder: (context) {
            if (initialLocation == null) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
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
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            initialCameraPosition: initialLocation!,
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
                                height: 300,
                                child: PlaceWidgetMap(
                                    ownerModel: selectedOwner!,
                                    onClose: () {
                                      setState(() {
                                        selectedOwner = null;
                                      });
                                    }),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
