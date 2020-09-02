//http://api.epump.com.ng/Branch/Tanks/{branchID} GET

import 'package:intl/intl.dart';

class Tank {
  String id;
  String productName;
  String name;
  dynamic maxCapacity;
  dynamic currentVolume;
  dynamic temperature;
  dynamic waterVolume;
  dynamic probeVolume;
  var lastProbeDate;
  var lastDischargeDate;
  dynamic lastDischargeVolume;

  Tank({this.id,this.productName,
    this.name,
    this.maxCapacity,
    this.currentVolume,
    this.temperature,
    this.waterVolume,
    this.probeVolume,
    this.lastProbeDate,
    this.lastDischargeDate,
    this.lastDischargeVolume});

  factory Tank.fromJson(Map<String, dynamic> json) {
    return Tank(
      id: json["id"] == null ? "" : json["id"],
      productName: json["productName"] == null ? "" : json["productName"],
      name: json["name"] == null ? "" : json["name"],
      maxCapacity: json["maxCapacity"] == null ? 0.00 : json["maxCapacity"],
      currentVolume:
      json["currentVolume"] == null ? 0.00 : json["currentVolume"],
      temperature: json["temperature"] == null ? 0.00 : json["temperature"],
      waterVolume: json["waterVolume"] == null ? 0.00 : json["waterVolume"],
      probeVolume: json["atgVolume"] == null ? 0.00 : json["atgVolume"],
      lastProbeDate:json["lastATGDate"]==null?"":DateFormat.yMMMMEEEEd().format(DateTime.parse(json["lastATGDate"])),
      lastDischargeDate:json["lastFillDate"]==null?"":DateFormat.yMMMMEEEEd().format(DateTime.parse(json["lastFillDate"])),
      lastDischargeVolume: json["lastFillVolume"] == null ? 0.00 : json["lastFillVolume"],
    );
  }
}

//{
//"id": "ef0c2d1d-ae64-4401-a95f-da925d1db527",
//"currentVolume": 15000,
//"waterVolume": null,
//"maxCapacity": 33000,
//"name": "AGO Tank 1",
//"lastUpdate": "2018-09-14T19:49:41.073",
//"lastSeen": "696 days ago",
//"hasATG": false,
//"productName": "AGO",
//"productId": "00000000-0000-0000-0000-000000000000",
//"atgWaterVolume": null,
//"atgVolume": null,
//"lastATGDate": null,
//"lastFillDate": null,
//"lastFillVolume": 0,
//"temperature": 0,
//"branchId": "6a237865-91ec-4c58-8b75-d7333e4cb4e6",
//"probeId": null,
//"reOrderLevel": null,
//"criticalReOrderLevel": null
//},
