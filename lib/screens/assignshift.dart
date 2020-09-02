import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/stores/branchstores/pumpstore.dart';
import 'package:epump/stores/branchstores/shiftstore.dart';
import 'package:epump/stores/staffstore/attendantstore.dart';
import 'package:epump/utils/branch/pump.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/utils/staff/branchstaff.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'loadingscreen.dart';

class AssignShift extends StatefulWidget {
  final shiftName;
  final shiftId;


  AssignShift({this.shiftName, this.shiftId});

  @override
  _AssignShiftState createState() => _AssignShiftState();
}

class _AssignShiftState extends State<AssignShift> {
  Pump pump;
  BranchStaff staff;
  TextEditingController _pumpController = TextEditingController();
  TextEditingController _staffController = TextEditingController();
  bool isDataFetched = false;
  int loadingDialogFlag = 0;

  @override
  void dispose() {
    _pumpController.dispose();
    _staffController.dispose();
    super.dispose();
  }

  void getStaff()async{
    final attendantStore = Provider.of<AttendantStore>(context,listen: false);
    String result = await attendantStore.getStaff();
    if(result == NetworkStrings.SUCCESSFUL){
      _staffController.text =
      "${attendantStore.staffs[0].firstName} ${attendantStore.staffs[0]
          .lastName}";
      staff = attendantStore.staffs[0];
    }setState(() {
      loadingDialogFlag++;
      if(loadingDialogFlag ==2){
        Navigator.of(context).pop();
      }
    });

  }

  void getPumps() async{
    final pumpStore = Provider.of<PumpStore>(context,listen: false);
    String result = await pumpStore.getPumps();
    if(result == NetworkStrings.SUCCESSFUL){
      _pumpController.text = pumpStore.pumps[0].displayName;
       pump = pumpStore.pumps[0];
    }
    setState(() {
      loadingDialogFlag++;
      if(loadingDialogFlag ==2){
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shiftStore = Provider.of<ShiftStore>(context);
    final pumpStore = Provider.of<PumpStore>(context);
    final attendantStore = Provider.of<AttendantStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isDataFetched) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Staffs & Staffs"));
        getStaff();
        getPumps();
        setState(() {
          isDataFetched = true;
        });
      }
    });
    return Scaffold(
      appBar: Constants.showCustomAppBar("Assign Shift"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return StructuredDialog(
                          giveRadius: false,
                          child: Observer(
                            builder: (_) =>
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: pumpStore.pumps.length,

                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _pumpController.text =
                                                pumpStore.pumps[index]
                                                    .displayName;
                                            pump = pumpStore.pumps[index];
                                          });
                                              },

                                        title: Text(
                                            pumpStore.pumps[index].displayName
                                        ),
                                      );
                                    }),
                          ),
                        );
                      });
                },
                child: TextField(
                  enabled: false,
                  controller: _pumpController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Pump",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),

                  ),
                  onSubmitted: (text) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {

                  showDialog(
                      context: context,
                      builder: (_) {
                        return StructuredDialog(
                          giveRadius: false,
                          child: Observer(
                            builder: (_) =>
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: attendantStore.staffs.length,

                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _staffController.text ="${attendantStore.staffs[index].firstName} ${attendantStore.staffs[index]
                                                .lastName}";
                                            staff = attendantStore.staffs[index];

                                          });
                                        },
                                        title: Text(
                                            "${attendantStore.staffs[index].firstName} ${attendantStore.staffs[index]
                                            .lastName}"
                                        ),
                                      );
                                    }),
                          ),
                        );
                      });
                },
                child: TextField(
                  controller: _staffController,
                  enabled: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Staff",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                  ),
                  onSubmitted: (text) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 60,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: RaisedButton(
                    onPressed: () async {
                      if(_pumpController.text.isNotEmpty && _staffController.text.isNotEmpty){
                        Navigator.of(context).push(LoadingWidget.showLoadingScreen("Creating shift"));
                        String result = await shiftStore.postAssignShift(widget.shiftName, staff.id, pump.id, widget.shiftId, 0.00);
                        Navigator.of(context).pop();
                        if(result == NetworkStrings.SUCCESSFUL){
                          await showDialog(context: context,builder: (_){
                            return StructuredDialog(
                              giveRadius: true,
                              child: FeedbackWidget(
                                title: "Success",
                                status: true,
                                message: result,
                              ),);
                          });
                          Navigator.of(context).pop();
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

                      }else{
                        showDialog(context: context,builder: (_){
                          return StructuredDialog(
                            giveRadius: true,
                            child: FeedbackWidget(
                              title: "Invaild",
                              status: false,
                              message: "All fields are required",
                            ),);
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    color: CustomColors.REMIS_PURPLE,
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
