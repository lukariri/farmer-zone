import 'dart:typed_data';
import '../../services/localizations.dart';
import '../../services/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_structure/models/city_sales.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapStats extends StatefulWidget {

  List<CitySales> citySales = [];

  MapStats(this.citySales);

  @override
  _MapStatsState createState() {
    return _MapStatsState();
  }

}

class _MapStatsState extends State<MapStats> {

  LatLng initialTarget = LatLng(30.2208068,71.5386542);
  bool isLoading = true;
  Set<Marker> _markers = {};
  Map<String, BitmapDescriptor> customIcons = {};

  @override
  void initState() {
    super.initState();
    initMapMarkers();
    getCurrentLocation().then((value) {
      if (value != null) {
        setState(() {
          initialTarget = LatLng(value.latitude, value.longitude);
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  initMapMarkers() {
    widget.citySales.forEach((element) {
      LatLng position = LatLng(element.latitude, element.longitude);
      addMarker(element, position);
    });
  }

  Future addMarker(CitySales element, LatLng position) async {
    //get custom icon from product
    if (customIcons[element.category.id] == null) {
      Uint8List bytes = (await NetworkAssetBundle(Uri.parse(element.category.urlImage)).load(element.category.urlImage))
          .buffer
          .asUint8List();
      // make sure to initialize before map loading
      BitmapDescriptor customIcon;
      customIcon = await BitmapDescriptor.fromBytes(
        utils.resizeImage(bytes, 100, 100)
      );
      customIcons[element.category.id] = customIcon;
    }

    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: element.city,
            snippet: '${element.sales} ${MyLocalizations.of(context).localization['sales']} for ${element.category.name}',
          ),
          icon: customIcons[element.category.id],
          onTap: () {

          }
      ));
    });
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyLocalizations.of(context).localization['statistics']
        ),
        backgroundColor: colorPrimary,
      ),
      body: (isLoading)?
      Center(
        child: CircularProgressIndicator(),
      ):
      Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 14.0,
          ),
          markers: _markers,
          //onMapCreated: _onMapCreated,
          compassEnabled: true,
        ),
      ),
    );
  }

}