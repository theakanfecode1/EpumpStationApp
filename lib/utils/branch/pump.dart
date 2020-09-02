//http://api.epump.com.ng/Branch/Pumps/6a237865-91ec-4c58-8b75-d7333e4cb4e6 GET

class Pump {
  String displayName;
  String id;
  String name;
  String lastSeen;
  dynamic openingReading;
  dynamic currentReading;
  dynamic totalReading;
  dynamic currentManualReading;

  Pump(
      {this.displayName,
      this.id,
      this.name,
      this.lastSeen,
      this.openingReading,
      this.totalReading,
      this.currentReading,
      this.currentManualReading});

  factory Pump.fromJson(Map<String, dynamic> json) {
    return Pump(
        displayName: json["displayName"] == null ? "" : json["displayName"],
        id: json["id"] == null ? "" : json["id"],
        name: json["name"] == null ? "" : json["name"],
        lastSeen: json["lastSeen"] == null ? "" : json["lastSeen"],
        openingReading:
            json["openingReading"] == null ? 0.00 : json["openingReading"],
        currentReading:
            json["currentReading"] == null ? 0.00 : json["currentReading"],
        currentManualReading: json["currentManualReading"] == null
            ? 0.00
            : json["currentManualReading"],
        totalReading: (json["currentReading"] == null
                ? 0.00
                : json["currentReading"]) -
            (json["openingReading"] == null ? 0.00 : json["openingReading"]));
  }
}

//{
//"id": "6b7fe65a-180d-490d-9416-6689581c6f9c",
//"name": "A1",
//"displayName": "AGO 1",
//"openingReading": null,
//"currentReading": 139180.8,
//"currentManualReading": 100,
//"branchId": "6a237865-91ec-4c58-8b75-d7333e4cb4e6",
//"productName": "AGO",
//"tankName": "AGO Tank 1",
//"manufacturer": "Wayne",
//"lastSeen": "692 days ago",
//"lastUpdate": "2018-09-19T12:46:45.66",
//"sellingPrice": 444.44,
//"status": null,
//"model": "Igem",
//"ratio": 1,
//"deviceName": null,
//"deviceId": null,
//"ipAddress": null,
//"ssid": null,
//"password": null,
//"posMultiplierPrice": null,
//"posMultiplierVolume": null
//},
