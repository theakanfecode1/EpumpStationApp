import 'package:epump/customwidgets/actionalertdialog.dart';
import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/assignshift.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/shiftstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ShiftAssignments extends StatefulWidget {
  final id;
  final closed;
  final shiftName;

  ShiftAssignments({this.id,this.closed,this.shiftName});

  @override
  _ShiftAssignmentsState createState() => _ShiftAssignmentsState();
}

class _ShiftAssignmentsState extends State<ShiftAssignments> {

  String shiftId;

  bool isDataFetched = false;

  closeShift() async{
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Closing Shfit"));
    final shiftStore = Provider.of<ShiftStore>(context,listen: false);
    String result = await  shiftStore.closeShift(shiftId, "");
    Navigator.of(context).pop();
    if(result == NetworkStrings.SUCCESSFUL){
      showDialog(context: context,builder: (_){
        return StructuredDialog(
          giveRadius: true,
          child: FeedbackWidget(
            title: "Success",
            status: true,
            message: "Shift Closed",
          ),);
      });
    }else{
      showDialog(context: context,builder: (_){
        return StructuredDialog(
          giveRadius: true,
          child: FeedbackWidget(
            title: "Error",
            status: false,
            message: result,
          ),);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shiftStore = Provider.of<ShiftStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(!isDataFetched){

        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Shift Assignments"));
        await shiftStore.getShiftAssignments(widget.id);
        Navigator.of(context).pop();
        setState(() {
          isDataFetched = true;
        });
      }

    });
    return Scaffold(
      appBar: Constants.showCustomAppBar("Shift Assignments"),
      floatingActionButton: widget.closed?null: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AssignShift(shiftName: widget.shiftName,shiftId: widget.id,)));
        },
        backgroundColor: CustomColors.REMIS_PURPLE,
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: CustomColors.REMIS_PURPLE,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  Constants.getAssetGeneralName("stopwatchdrawer", "svg"),
                  color: Colors.white,
                  width: 80,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Observer(
              builder: (_) => ListView.builder(
                  itemCount: shiftStore.shiftAssignments.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          shiftId = shiftStore.shiftAssignments[index].shiftId;
                        });
                        showDialog(
                            context: context,
                            builder: (_) {
                              return StructuredDialog(
                                giveRadius: true,
                                child: ActionAlertDialog(
                                  title: "CLOSE SHIFT ASSIGNMENT",
                                  message:
                                      "Are you sure you want to close this Shift Assignment",
                                  function: closeShift,
                                ),
                              );
                            });
                      },
                      child: CustomListCard(
                        shiftName:
                            "${shiftStore.shiftAssignments[index].firstName} ${shiftStore.shiftAssignments[index].lastName}",
                        pumpName: shiftStore.shiftAssignments[index].pumpName,
                        openingReading: Constants.formatThisInput(
                            shiftStore.shiftAssignments[index].openingReading),
                        closingReading: shiftStore.shiftAssignments[index].closingReading == 0.00?"" :Constants.formatThisInput(
                            shiftStore.shiftAssignments[index].closingReading),

                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final shiftName;
  final pumpName;
  final openingReading;
  final closingReading;


  CustomListCard({this.shiftName, this.pumpName, this.openingReading,this.closingReading});

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
            Icon(Icons.account_circle,size: 40,),
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
                    pumpName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "opening: $openingReading",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),


                      ),
                      Text(
                        closingReading==""?"":"closing: $closingReading",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      SizedBox(width: 3,)
                    ],
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
