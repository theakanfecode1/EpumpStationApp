import 'package:epump/screens/addmaintenance.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/requestdetails.dart';
import 'package:epump/stores/branchstores/maintenancerequeststore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'loadingscreen.dart';

class Maintenance extends StatefulWidget {
  @override
  _MaintenanceState createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    final requestStore = Provider.of<MaintenanceRequestStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context)
          .push(LoadingWidget.showLoadingScreen("Fetching Requests"));
      await requestStore.getMaintenanceRequest();
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Maintenance",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddMaintenance())),
        backgroundColor: CustomColors.REMIS_PURPLE,
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: requestStore.requests.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetails(request:requestStore.requests[index] ,))),
              child: CustomListCard(
                type: requestStore.requests[index].type,
                typeName: requestStore.requests[index].typeName,
                description: requestStore.requests[index].description,
                date: requestStore.requests[index].date.toString(),
                branchName: requestStore.requests[index].branchName,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final typeName;
  final type;
  final branchName;
  final description;
  final date;

  CustomListCard(
      {this.typeName, this.type, this.branchName, this.description, this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CustomColors.REMIS_LIGHT_GREY),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                Constants.getAssetGeneralName("maintenance", "svg"),
                width: 40,
                color: CustomColors.REMIS_PURPLE,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$typeName($type)",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    branchName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
