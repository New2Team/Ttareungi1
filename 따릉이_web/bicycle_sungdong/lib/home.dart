import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SungdongBikeMap extends StatefulWidget {
  const SungdongBikeMap({super.key});

  @override
  State<SungdongBikeMap> createState() => _SungdongBikeMapState();
}

class _SungdongBikeMapState extends State<SungdongBikeMap> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();

  List<BikeMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    fetchBikeData();
  }

  Future<void> fetchBikeData() async {
    const url = 'http://127.0.0.1:8000/bike/sungdong'; // 실제 배포 시 외부 도메인으로 변경 필요
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<BikeMarker> loadedMarkers = [];

      for (var station in data) {
        final lat = double.tryParse(station["stationLatitude"]);
        final lng = double.tryParse(station["stationLongitude"]);
        final name = station["stationName"];
        final bikes = station["parkingBikeTotCnt"];

        if (lat != null && lng != null) {
          loadedMarkers.add(
            BikeMarker(
              LatLng(lat, lng),
              name: name,
              bikes: bikes,
            ),
          );
        }
      }

      setState(() {
        _markers = loadedMarkers;
      });
    } else {
      debugPrint("API 요청 실패: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("성동구 따릉이 대여소 현황")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ 
          Center(
            child: SizedBox(
              width: 450,
              height: 600,
              child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(37.5610, 127.0386),
                initialZoom: 13,
                onTap: (_, __) => _popupController.hideAllPopups(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers: _markers,
                    popupController: _popupController,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        final bike = marker as BikeMarker;
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(bike.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14)),
                                Text("대여 가능: ${bike.bikes}대"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
                      ),
            ),
          ),
        ]
      ),
    );
  }
}

// 커스텀 마커 클래스 정의
class BikeMarker extends Marker {
  final String name;
  final String bikes;

  BikeMarker(
    LatLng point, {
    required this.name,
    required this.bikes,
  }) : super(
          point: point,
          width: 40,
          height: 40,
          child: Icon(Icons.pedal_bike, color: Colors.green, size: 30),
        );
}