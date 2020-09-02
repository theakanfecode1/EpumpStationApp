import 'package:epump/screens/addattendant.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/stores/staffstore/attendantstore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'loadingscreen.dart';

class Attendants extends StatefulWidget {
  @override
  _AttendantsState createState() => _AttendantsState();
}

class _AttendantsState extends State<Attendants> {
  @override
  Widget build(BuildContext context) {
    final attendantStore = Provider.of<AttendantStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context)
          .push(LoadingWidget.showLoadingScreen("Fetching Staffs"));
      await attendantStore.getStaff();
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Attendants",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddAttendant())),
        backgroundColor: CustomColors.REMIS_PURPLE,
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
      body: Observer(
        builder:(_) => ListView.builder(
          itemCount: attendantStore.staffs.length,
          itemBuilder: (context, index) {
            return CustomListCard(
              name: "${attendantStore.staffs[index].firstName} ${attendantStore.staffs[index].lastName}",
              phone: attendantStore.staffs[index].phone,
              email: attendantStore.staffs[index].email,
            );
          },
        ),
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;


  CustomListCard({this.name, this.phone, this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 110,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: CustomColors.REMIS_LIGHT_GREY),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20,),
            SvgPicture.asset(
              Constants.getAssetGeneralName("group", "svg"),
              width: 40,
              color: CustomColors.REMIS_PURPLE,
            ),
            SizedBox(width: 20,),

//            SizedBox(
//              width: 20,
//            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(height: 5,),
                Text(
                  phone,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                SizedBox(height: 5,),

                Text(
                  email,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
