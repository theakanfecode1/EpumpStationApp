import 'package:epump/customwidgets/doubletextfielddialog.dart';
import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/customwidgets/wave_widget.dart';
import 'package:epump/stores/branchstores/tankstore.dart';
import 'package:epump/utils/branch/tank.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'loadingscreen.dart';

class TankDetails extends StatefulWidget {
  final Tank tank;

  TankDetails({this.tank});

  @override
  _TankDetailsState createState() => _TankDetailsState();
}

class _TankDetailsState extends State<TankDetails> {
  double calculateWaveHeight(dynamic max, dynamic current) {
    double temp = ((max - current) / max) * 100;
    return (100 - temp);
  }

  Color setWaveColor(dynamic value) {
    if (value <= 30.00) {
      return CustomColors.REMIS_RED;
    } else if (value <= 40.00) {
      return CustomColors.REMIS_WAVE_ORANGE;
    } else if (value < 70.00) {
      return CustomColors.REMIS_WAVE_BLUE;
    } else {
      return CustomColors.REMIS_WAVE_GREEN;
    }
  }

  dataFormTankFillDialog(String plateNumber, String openingDip) async {
    final tankStore = Provider.of<TankStore>(context,listen: false);
    if (plateNumber.isNotEmpty && openingDip.isNotEmpty) {
      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Filling"));
      String result =
          await tankStore.startFill(plateNumber, widget.tank.id, openingDip);
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
                  message: "Fill complete",
                ),
              );
            });
      }
      else if(result == NetworkStrings.SERVER_ERROR){
        showDialog(
            context: context,
            builder: (_) {
              return StructuredDialog(
                giveRadius: true,
                child: FeedbackWidget(
                  title: "Error",
                  status: false,
                  message: "No records found for Tank Probe",
                ),
              );
            });
      }
      else {
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
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return StructuredDialog(
              giveRadius: true,
              child: FeedbackWidget(
                title: "Invalid Input",
                status: false,
                message: "All fields are required",
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.showCustomAppBar(widget.tank.name),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 305),
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: CustomColors.REMIS_PURPLE,
                  ),
                  Positioned(
                    top: 80,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                WaveWidget(
                                    80.0,
                                    CustomColors.REMIS_PURPLE,
                                    setWaveColor(calculateWaveHeight(
                                        widget.tank.maxCapacity,
                                        widget.tank.currentVolume)),
                                    calculateWaveHeight(widget.tank.maxCapacity,
                                        widget.tank.currentVolume)),
                                Text(
                                  "Current Volume",
                                  style: TextStyle(
                                      color: CustomColors.REMIS_PURPLE,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Constants.formatThisInput(
                                      widget.tank.currentVolume),
                                  style: TextStyle(
                                      color: CustomColors.REMIS_DARK_PURPLE,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Litres",
                                  style: TextStyle(
                                      color: CustomColors.REMIS_PURPLE,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                WaveWidget(80.0, CustomColors.REMIS_PURPLE,
                                    CustomColors.REMIS_WAVE_GREEN, 98),
                                Text(
                                  "Max. capacity",
                                  style: TextStyle(
                                      color: CustomColors.REMIS_PURPLE,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Constants.formatThisInput(
                                      widget.tank.maxCapacity),
                                  style: TextStyle(
                                      color: CustomColors.REMIS_DARK_PURPLE,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Litres",
                                  style: TextStyle(
                                      color: CustomColors.REMIS_PURPLE,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Table(
                    border: TableBorder.symmetric(
                        inside: BorderSide(
                            color: Colors.grey[200].withOpacity(
                      0.9,
                    ))),
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: GridList(
                            image:
                                Constants.getAssetGeneralName("measure", "svg"),
                            title: "Last Discharge Volume",
                            amount: Constants.formatThisInput(
                                widget.tank.lastDischargeVolume),
                            size: 30,
                          ),
                        ),
                        TableCell(
                          child: GridList(
                            image: Constants.getAssetGeneralName(
                              "calendar",
                              "svg",
                            ),
                            title: "Last Discharge Date",
                            amount: widget.tank.lastDischargeDate,
                            size: 27,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: GridList(
                            image: Constants.getAssetGeneralName("wave", "svg"),
                            title: "Water Volume",
                            amount: Constants.formatThisInput(
                                widget.tank.waterVolume),
                            size: 30,
                          ),
                        ),
                        TableCell(
                          child: GridList(
                            image: Constants.getAssetGeneralName(
                                "thermometer", "svg"),
                            title: "Temperature",
                            amount: Constants.formatThisInput(
                                    widget.tank.temperature) +
                                " degrees",
                            size: 10,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: GridList(
                            image: Constants.getAssetGeneralName(
                              "calendar",
                              "svg",
                            ),
                            title: "Last Probe Date",
                            amount: widget.tank.lastProbeDate,
                            size: 27,
                          ),
                        ),
                        TableCell(
                          child: GridList(
                            image:
                                Constants.getAssetGeneralName("measure", "svg"),
                            title: "Last Probe Volume",
                            amount: Constants.formatThisInput(
                                widget.tank.probeVolume),
                            size: 30,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return DoubleTextFieldDialog(
                        title: "INPUT MANUAL DIPPING",
                        inputTypeOne: TextInputType.text,
                        inputTypeTwo:
                            TextInputType.numberWithOptions(decimal: true),
                        labelOne: "Truck Plate Number",
                        labelTwo: "Opening Dip",
                        function: dataFormTankFillDialog,
                      );
                    });
              },
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: CustomColors.REMIS_PURPLE,
                        radius: 30,
                      ),
                      SvgPicture.asset(
                        Constants.getAssetGeneralName("fabicon", "svg"),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    "Start Fill",
                    style: TextStyle(
                        color: CustomColors.REMIS_PURPLE, fontSize: 12),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class GridList extends StatelessWidget {
  final String amount;
  final String title;
  final String image;
  final double size;

  GridList({this.amount, this.title, this.image, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        height: 105,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              image,
              color: CustomColors.REMIS_PURPLE,
              width: size,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
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
