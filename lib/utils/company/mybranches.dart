//http://api.epump.com.ng/Company/MyBranches
class MyBranches{
  String branchId;
  String name;
  String city;
  String state;
  String street;
  dynamic pmsTotalVolume;
  dynamic agoTotalVolume;
  dynamic dpkTotalVolume;


  MyBranches({this.branchId, this.name, this.city, this.state, this.street,
      this.pmsTotalVolume, this.agoTotalVolume, this.dpkTotalVolume});

  factory MyBranches.fromJson(Map<String,dynamic> json){
    return MyBranches(
      branchId: json["id"]==null?"":json["id"],
      name: json["name"]==null?"":json["name"],
      city: json["city"]==null?"":json["city"],
      state: json["state"]==null?"":json["state"],
      street: json["street"]==null?"":json["street"],
      pmsTotalVolume:  json["pmsTotalVolume"]==null?0.00:json["pmsTotalVolume"],
      agoTotalVolume:  json["agoTotalVolume"]==null?0.00:json["agoTotalVolume"],
      dpkTotalVolume:  json["dpkTotalVolume"]==null?0.00:json["dpkTotalVolume"],

    );
  }

}

//[
//{
//"dealerId": "f667010e-286f-4542-b3cf-30c057c9a612",
//"name": "Ascon Akilo ",
//"phone": "08000000000",
//"email": "akilo@asconoil.com",
//"street": "Akilo",
//"city": "Ogba",
//"state": "Lagos",
//"country": "Nigeria",
//"dealerName": "Fuel Metrics Dealer",
//"pefStationId": null,
//"companyId": "b2e245d3-dd83-40fd-8bd5-53bd32810744",
//"daySaleEndHour": null,
//"repId": null,
//"userId": null,
//"companyName": "Fuel Metrics",
//"companyLogoUrl": "/content/UploadedImages/admin@epump.com.ng/753ce417-54c5-41fd-b4a9-3d782736040c_image_admin@epump.com.ng_logo.png",
//"pmsTotalVolume": 0,
//"agoTotalVolume": 0,
//"dpkTotalVolume": 0,
//"date": "2019-07-14T19:49:41.057",
//"engagementLevel": "Auto",
//"online": true,
//"wmStationId": null,
//"groupId": "2cf4bc86-8dc7-4b81-ac09-7143f473dc0c",
//"groupName": "West side",
//"serviceType": null,
//"sendReportMail": "Active",
//"ratio": 0,
//"totalVolume": 0,
//"pmsPercentage": 0,
//"agoPercentage": 0,
//"dpkPercentage": 0,
//"displayProduct": null,
//"id": "6a237865-91ec-4c58-8b75-d7333e4cb4e6"
//}
//]