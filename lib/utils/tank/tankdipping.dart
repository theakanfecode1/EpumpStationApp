

import 'package:intl/intl.dart';

class TankDipping{
  dynamic actualVolume;
  String recordedOn;
  String date;

  TankDipping({this.actualVolume, this.recordedOn, this.date});

  factory TankDipping.fromJson(Map<String,dynamic> json){
    return TankDipping(
      actualVolume: json["actualVolume"] == null ? 0.00 :json["actualVolume"],
      recordedOn: json["recordedOn"] == null ? "" :json["recordedOn"],
      date: json["date"] == null?"": DateFormat.yMMMMEEEEd().format(DateTime.parse(json["date"]))+" "+DateFormat.jm().format(DateTime.parse(json["date"])),


    );
  }


}