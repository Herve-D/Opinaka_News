import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opinakanews/model/Result.dart';
import 'package:opinakanews/util/Database.dart';

/// Page affichant une carte avec l'utilisateur et les documents géolocalisés.
class Carte extends StatefulWidget {
  @override
  _CarteState createState() => _CarteState();
}

class _CarteState extends State<Carte> {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _locateUser().then((position) {
      setState(() {
        userLocation = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.carte')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _locateUser().then((value) {
                setState(() {
                  userLocation = value;
                });
              });
            },
          )
        ],
      ),
      body: Center(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:
              CameraPosition(target: LatLng(48.8456961, 2.5811746), zoom: 5),
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }

  /// Initialisation de la carte.
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final spots = await DbHelper.db.getAllResults();
    setState(() {
      mapController = controller;
      _markers.clear();
      for (final spot in spots) {
        final marker = Marker(
          markerId: MarkerId(spot.resume),
          position: LatLng(double.parse(spot.lat), double.parse(spot.long)),
          infoWindow: InfoWindow(
            title: _getText(spot.resume),
            snippet: spot.status,
            onTap: () {
              Result.readView(context, spot);
            },
          ),
        );
        _markers[spot.resume] = marker;
      }
    });
  }

  /// Récupération du titre du document.
  _getText(String txt) {
    const start = '<header>';
    const end = '</header>';
    return txt.substring(txt.indexOf(start) + start.length, txt.indexOf(end));
  }

  /// Récupération de la géolocalisation de l'utilisateur.
  Future<Position> _locateUser() async {
    try {
      userLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }
}
