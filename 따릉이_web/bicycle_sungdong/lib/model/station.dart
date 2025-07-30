class BikeStation {
  final String stationName;
  final String stationId;
  final double lat;
  final double lng;
  final int parking;
  final int rackTotal;
  final double sharedPercent;

  BikeStation({
    required this.stationName,
    required this.stationId,
    required this.lat,
    required this.lng,
    required this.parking,
    required this.rackTotal,
    required this.sharedPercent,
  });

  factory BikeStation.fromJson(Map<String, dynamic> json) {
    return BikeStation(
      stationName: json['stationName'],
      stationId: json['stationId'],
      lat: double.parse(json['stationLatitude']),
      lng: double.parse(json['stationLongitude']),
      parking: int.parse(json['parkingBikeTotCnt']),
      rackTotal: int.parse(json['rackTotCnt']),
      sharedPercent: double.parse(json['shared']),
    );
  }
}