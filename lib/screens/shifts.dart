import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/addshift.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/screens/shiftassignments.dart';
import 'package:epump/screens/shiftbankdeposit.dart';
import 'package:epump/stores/branchstores/shiftstore.dart';
import 'package:epump/stores/branchstores/tankstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Shifts extends StatefulWidget {
  @override
  _ShiftsState createState() => _ShiftsState();
}

class _ShiftsState extends State<Shifts> {
  String id;
  String comment="";
  bool isDataFetched = false;

  void closeShift(String comment) async {
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Closing Shfit"));
    final shiftStore = Provider.of<ShiftStore>(context, listen: false);
    String result = await shiftStore.closeShift(id, comment);
    Navigator.of(context).pop();
    if (result == NetworkStrings.SUCCESSFUL) {
      showDialog(
          context: context,
          builder: (_) {
            return StructuredDialog(
              giveRadius: true,
              child: FeedbackWidget(
                title: "Success",
                status: true,
                message: "Shift Closed",
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return StructuredDialog(
              giveRadius: true,
              child: FeedbackWidget(
                title: "Error",
                status: false,
                message: result,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shiftStore = Provider.of<ShiftStore>(context);
    final tankStore = Provider.of<TankStore>(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isDataFetched) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Shifts"));
        await shiftStore.getShifts();
        Navigator.of(context).pop();
        setState(() {
          isDataFetched = true;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Shifts",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AddShift())),
        backgroundColor: CustomColors.REMIS_PURPLE,
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: shiftStore.shifts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (builder) {
                        return Container(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShiftAssignments(
                                            id: shiftStore.shifts[index].id,
                                            closed:
                                                shiftStore.shifts[index].closed,
                                            shiftName:
                                                shiftStore.shifts[index].name,
                                          )));
                                },
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Shift Assignments",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              if (!shiftStore.shifts[index].closed)
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.4,
                                ),
                              if (!shiftStore.shifts[index].closed)
                                ListTile(
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      id = shiftStore.shifts[index].id;
                                    });
                                    Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Tanks"));
                                    String result = await tankStore.getTanks();
                                    Navigator.of(context).pop();
                                    if(result == NetworkStrings.SUCCESSFUL){
                                      showDialog(context: context,builder: (_){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          insetPadding: EdgeInsets.all(10),
                                          child: Container(
                                            height: 700,
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top:20.0),
                                                  child: Text(
                                                    "INPUT TANKS DIPPING",
                                                    style: TextStyle(
                                                        color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
                                                  ),
                                                ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: tankStore.tanks.length,
                                                    itemBuilder: (context,index){
                                                      return Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          onSubmitted: (text){
                                                            FocusScope.of(context).nextFocus();
                                                            setState(() {
                                                              comment+="|"+text;
                                                            });
                                                          },
                                                          textInputAction: TextInputAction.next,
                                                          decoration: Constants.getInputDecoration("${tankStore.tanks[index].name} Dipping", true),
                                                        ),
                                                      );
                                                    }),
                                                Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      bottomRight: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () => Navigator.of(context).pop(),
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(bottomLeft: Radius.circular(10)),
                                                              color: Colors.white,
                                                            ),
                                                            height: 70,
                                                            child: Text(
                                                              "NO",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 20,
                                                                  color: CustomColors.REMIS_PURPLE),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                            closeShift(comment);

                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            height: 70,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(bottomRight: Radius.circular(7)),
                                                              color: CustomColors.REMIS_PURPLE,
                                                            ),
                                                            child: Text(
                                                              "YES",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 20,
                                                                  color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Close Shift",
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ShiftBankDeposit(shiftId: shiftStore.shifts[index].id,)));
                                },
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Bank Deposits",
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: CustomListCard(
                  shiftName: shiftStore.shifts[index].name,
                  date: shiftStore.shifts[index].endTime == ""
                      ? shiftStore.shifts[index].startTime
                      : shiftStore.shifts[index].startTime +
                          " - " +
                          shiftStore.shifts[index].endTime,
                ));
          },
        ),
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final shiftName;
  final date;

  CustomListCard({this.shiftName, this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            SizedBox(
              width: 20,
            ),
            SvgPicture.asset(
              Constants.getAssetGeneralName("stopwatchdrawer", "svg"),
              width: 30,
              color: CustomColors.REMIS_PURPLE,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shiftName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
