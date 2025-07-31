import 'dart:convert';
import 'package:bicycle_sungdong/components/menupanel.dart';
import 'package:bicycle_sungdong/view/post_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';

class SungdongBikeMap extends StatefulWidget {
  const SungdongBikeMap({super.key});

  @override
  State<SungdongBikeMap> createState() => _SungdongBikeMapState();
}

class _SungdongBikeMapState extends State<SungdongBikeMap> {
  final MapController _mapController = MapController();
  List<BikeMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    fetchBikeData();
  }

  Future<void> fetchBikeData() async {
    const url = 'http://127.0.0.1:8000/bike/sungdong';
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
            BikeMarker(LatLng(lat, lng), name: name, bikes: bikes),
          );
        }
      }

      setState(() {
        _markers = loadedMarkers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      drawer: MenuPanel(
        selectedIndex: 0,
        onMenuSelected: (int idx) {
          if (idx == 0) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => GesigleBoardPage()));
          }
        },
      ),
      appBar: AppBar(
        titleSpacing: 16,
        backgroundColor: Colors.green.shade800, 
        elevation: 2,
        leading: ResponsiveVisibility(
          hiddenConditions: [Condition.largerThan(name: TABLET)],
          child: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu_rounded, size: 28, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ),
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              "성동구 따릉이 대여소 현황",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          ResponsiveVisibility(
            hiddenConditions: [Condition.smallerThan(name: DESKTOP)],
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => GesigleBoardPage()));
                },
                icon: Icon(Icons.campaign, color: Colors.white),
                label: Text(
                  '공지사항',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            isWide
                ? Row(
                  children: [
                    // 🟩 지도 영역
                    Expanded(flex: 7, child: buildMap()),
                    VerticalDivider(width: 32),
                    // 🟦 게시판 영역
                    Expanded(flex: 3, child: buildBoardPreview()),
                  ],
                )
                : Center(child: buildMap()),
      ),
    );
  }

  // 지도 빌드 함수
  Widget buildMap() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(37.5610, 127.0386),
        initialZoom: 13,
        onTap: (_, __) {},
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: _markers.map((bike) {
            return Marker(
              width: 40,
              height: 40,
              point: bike.point,
              child:  GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(bike.name),
                        content: Text("대여 가능: ${bike.bikes}대"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("닫기"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.pedal_bike, color: Colors.green, size: 30),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
  
  }

  //공지사항
  Widget buildBoardPreview() {
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('gesigle')
              .orderBy('datetime', descending: true)
              .limit(5)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Text("공지사항이 없습니다."),
          );
        }

        final notices =
            snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['title'] ?? '제목 없음';
            }).toList();

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "최신 공지사항",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text("・ ${notices[index]}"),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

// 커스텀 마커
class BikeMarker {
  final LatLng point;
  final String name;
  final String bikes;

  BikeMarker(this.point, {required this.name, required this.bikes});
}
