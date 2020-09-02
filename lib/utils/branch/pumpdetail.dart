//http://api.epump.com.ng/Branch/Pumps/Detail/6b7fe65a-180d-490d-9416-6689581c6f9c GET

import 'package:intl/intl.dart';

class PumpDetail {
  String name;
  dynamic totalSale;
  dynamic totalVolume;
  var lastTransactionTime;
  dynamic lastTransactionVolume;
  dynamic openingReading;
  dynamic currentReading;

  PumpDetail(
      {this.name,
      this.totalSale,
      this.totalVolume,
      this.lastTransactionTime,
      this.lastTransactionVolume,
      this.openingReading,
      this.currentReading});

  factory PumpDetail.fromJson(Map<String, dynamic> json) {
    return PumpDetail(
        name: json["name"]==null?"":json["name"],
        totalSale: json["totalSale"]==null?0.00:json["totalSale"],
        totalVolume: json["totalVolume"]==null?0.00:json["totalVolume"],
        lastTransactionTime:  json["lastTransactionTime"]==null?"":DateFormat.yMMMMEEEEd().format(DateTime.parse(json["lastTransactionTime"]))+" "+DateFormat.jm().format(DateTime.parse(json["lastTransactionTime"])),
        lastTransactionVolume: json["lastTransactionVolume"]==null?0.00:json["lastTransactionVolume"],
        openingReading: json["openingReading"]==null?0.00:json["openingReading"],
        currentReading: json["currentReading"]==null?0.00:json["currentReading"],
    );
  }
}

//{
//"tankId": "ef0c2d1d-ae64-4401-a95f-da925d1db527",
//"name": "A1",
//"displayName": "AGO 1",
//"lastReading": 139180.8,
//"dateCreated": "2018-09-14T19:57:56.3",
//"createdBy": null,
//"branchId": "6a237865-91ec-4c58-8b75-d7333e4cb4e6",
//"ratio": 1,
//"tankName": "AGO Tank 1",
//"currentSellingPrice": 444.44,
//"productName": "AGO",
//"productId": "9878b8da-6c82-4792-a1ef-c444c6726ea9",
//"connected": true,
//"branchName": "Ascon Akilo ",
//"addressId": null,
//"manufacturer": "Wayne",
//"model": "Igem",
//"version": "3.0",
//"status": null,
//"deviceId": null,
//"dateModified": "2018-09-19T12:46:45.66",
//"totalMultiplier": 10,
//"amountMultiplier": null,
//"volumeMultiplier": null,
//"currentReading": 0,
//"rtt": 0,
//"locked": false,
//"percentageVariance": null,
//"standardCalibration": null,
//"totalizerPrepend": null,
//"needToResolve": false,
//"lastTransactionVolume": 0,
//"lastTransactionTime": "0001-01-01T00:00:00",
//"totalSale": 0,
//"totalVolume": 0,
//"openingReading": 0,
//"closingReading": 0,
//"attendant": null,
//"deviceName": null,
//"ipAddress": null,
//"ssid": null,
//"password": null,
//"posMultiplierPrice": null,
//"posMultiplierVolume": null,
//"companyId": "b2e245d3-dd83-40fd-8bd5-53bd32810744",
//"dealerId": "f667010e-286f-4542-b3cf-30c057c9a612",
//"maxReading": null,
//"id": "6b7fe65a-180d-490d-9416-6689581c6f9c"
//}
