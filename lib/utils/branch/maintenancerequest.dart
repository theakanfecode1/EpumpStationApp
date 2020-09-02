//http://api.epump.com.ng/Branch/MaintenanceRequests/branchID

import 'package:intl/intl.dart';

class MaintenanceRequest{
  String type;
  String typeName;
  String description;
  dynamic date;
  String branchName;
  String companyId;
  String id;
  bool resolved;

  MaintenanceRequest({this.type, this.typeName, this.description, this.date,
      this.branchName, this.companyId, this.id,this.resolved});

  factory MaintenanceRequest.fromJson(Map<String,dynamic> json){
    return MaintenanceRequest(
      type: json["type"] == null?"":json["type"],
      typeName: json["typeName"] == null?"":json["typeName"],
      description: json["description"] == null?"":json["description"],
      date: json["date"] == null?"":DateFormat.yMMMMEEEEd().format(DateTime.parse(json["date"]))+" "+DateFormat.jm().format(DateTime.parse(json["date"])),
      branchName: json["branchName"] == null?"":json["branchName"],
      companyId: json["companyId"] == null?"":json["companyId"],
      id: json["id"] == null?"":json["id"],
      resolved: json["resolved"]


    );
  }


}

//type": "Pump",
//"typeName": "AGO 1",
//"description": "hsh",
//"date": "2020-08-09T09:04:24.77",
//"scheduleDate": null,
//"resolveDate": null,
//"resolved": false,
//"amount": null,
//"branchId": "6a237865-91ec-4c58-8b75-d7333e4cb4e6",
//"branchName": "Ascon Akilo ",
//"companyId": "b2e245d3-dd83-40fd-8bd5-53bd32810744",
//"images": [],
//"comment": null,
//"id": "907a7333-27da-454a-8b92-3d7a510da3db"