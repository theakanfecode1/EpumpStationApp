import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/screens/pumpdetails.dart';
import 'package:epump/screens/pumptransactions.dart';
import 'package:epump/screens/recordpumptransaction.dart';
import 'package:epump/stores/branchstores/pumpstore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Pumps extends StatefulWidget {
  @override
  _PumpsState createState() => _PumpsState();
}

class _PumpsState extends State<Pumps> {
  @override
  Widget build(BuildContext context) {
    final pumpStore = Provider.of<PumpStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context)
          .push(LoadingWidget.showLoadingScreen("Fetching Pumps"));
      await pumpStore.getPumps();
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Pumps",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      body: Observer(
        builder: (_) => ListView.builder(
            itemCount: pumpStore.pumps.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PumpDetails(id: pumpStore.pumps[index].id,currentReading: pumpStore.pumps[index].currentReading,))
                                    );
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "View Details",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.4,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PumpTransactions(id: pumpStore.pumps[index].id,displayName: pumpStore.pumps[index].displayName,)));
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "View Transactions",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.4,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RecordPumpTransaction(name:pumpStore.pumps[index].name,id:pumpStore.pumps[index].id,manualReading:pumpStore.pumps[index].currentManualReading )));
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Record Transaction",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.4,
                                ),
                                ListTile(
                                  onTap: () => Navigator.of(context).pop(),
                                  title: Center(
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: CustomListCard(
                      displayName: pumpStore.pumps[index].displayName,
                      openingReading: Constants.formatThisInput(pumpStore.pumps[index].openingReading),
                      currentReading: Constants.formatThisInput(pumpStore.pumps[index].currentReading),
                      totalVolume: Constants.formatThisInput(pumpStore.pumps[index].totalReading),
                      lastSeen: pumpStore.pumps[index].lastSeen,
                    ),
                  ));
            }),
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final String displayName;
  final String openingReading;
  final String currentReading;
  final String totalVolume;
  final String lastSeen;

  CustomListCard(
      {this.displayName,
      this.openingReading,
      this.currentReading,
      this.totalVolume,
      this.lastSeen});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 135,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey[200]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 10,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  color: CustomColors.REMIS_PURPLE),
            ),
//            SizedBox(
//              width: 20,
//            ),
            Image.asset(
              Constants.getAssetGeneralName("purplepump", "png"),
              width: 75,
              height: 75,
            ),
//            SizedBox(
//              width: 20,
//            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  displayName,
                  style: TextStyle(
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
                Text(
                  "Opening Reading:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Text(
                  "Current Reading:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Text(
                  "Total Volume:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  lastSeen,
                  style: TextStyle(
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Text(
                  openingReading,
                  style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Text(
                  currentReading,
                  style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Text(
                  totalVolume,
                  style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: CustomColors.REMIS_PURPLE,
              size: 20,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
