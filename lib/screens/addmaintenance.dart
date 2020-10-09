import 'dart:io';

import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/maintenancerequeststore.dart';
import 'package:epump/stores/branchstores/pumpstore.dart';
import 'package:epump/stores/branchstores/tankstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMaintenance extends StatefulWidget {
  @override
  _AddMaintenanceState createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  TextEditingController _requestTypeController = TextEditingController();
  TextEditingController _typeNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  int loadingDialogFile = 0;
  bool isDataFetched = false;
  File _imageFile;

  @override
  void dispose() {
    _requestTypeController.dispose();
    _typeNameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void getMProperties()async{
    final maintenanceStore = Provider.of<MaintenanceRequestStore>(context,listen: false);
    String result = await maintenanceStore.getMProperties();
    if(result == NetworkStrings.SUCCESSFUL){
      _requestTypeController.text = maintenanceStore.properties[0];
    }
    setState(() {
      loadingDialogFile++;
      if(loadingDialogFile == 2){
        Navigator.of(context).pop();
      }
    });

  }

  void getPumps()async{
    final pumpStore = Provider.of<PumpStore>(context,listen: false);
    String result = await pumpStore.getPumps();
    if(result == NetworkStrings.SUCCESSFUL){
      _typeNameController.text = pumpStore.pumps[0].displayName;
    }
    setState(() {
      loadingDialogFile++;
      if(loadingDialogFile == 2){
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pumpStore = Provider.of<PumpStore>(context);
    final tankStore = Provider.of<TankStore>(context);
    final maintenanceStore = Provider.of<MaintenanceRequestStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isDataFetched) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Loading Assets and Pumps"));
        getPumps();
        getMProperties();
        setState(() {
          isDataFetched = true;
        });
      }
    });

    return Scaffold(
      appBar: Constants.showCustomAppBar("Submit Maintenance Request"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: CustomColors.REMIS_PURPLE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset(
                    Constants.getAssetGeneralName("maintenance", "svg"),
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
                        return Dialog(
                          insetPadding: EdgeInsets.all(10.0),
                          child: Observer(
                            builder: (_) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: maintenanceStore.properties.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () async {
                                      switch (maintenanceStore.properties[index]
                                          .toLowerCase()) {
                                        case "pump":
                                          if (maintenanceStore.properties[index]
                                                  .toLowerCase() ==
                                              "pump") {
                                            Navigator.of(context).push(
                                                LoadingWidget.showLoadingScreen(
                                                    "Fetching Pumps"));
                                            await pumpStore.getPumps();
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _typeNameController.text = pumpStore
                                                  .pumps[0].displayName;
                                            });
                                          }
                                          break;
                                        case "tank":
                                          if (maintenanceStore.properties[index]
                                                  .toLowerCase() ==
                                              "tank") {
                                            Navigator.of(context).push(
                                                LoadingWidget.showLoadingScreen(
                                                    "Fetching Tanks"));
                                            await tankStore.getTanks();
                                            _typeNameController.text =
                                                tankStore.tanks[0].name;

                                            Navigator.of(context).pop();
                                          }
                                          break;
                                        default:
                                      }

                                      setState(() {
                                        _requestTypeController.text =
                                            "${maintenanceStore.properties[index]}";
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    title: Text(
                                        "${maintenanceStore.properties[index]}"),
                                  );
                                }),
                          ),
                        );
                      });
                },
                child: TextField(
                  controller: _requestTypeController,
                  enabled: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Request type",
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
                    contentPadding: EdgeInsets.all(20),
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
              height: 20,
            ),
            if (_requestTypeController.text.toLowerCase() !=
                "Canopy".toLowerCase())
              Column(
                children: <Widget>[
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
                                  builder: (_) => ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _requestTypeController.text
                                                  .toLowerCase() ==
                                              "pump"
                                          ? pumpStore.pumps.length
                                          : tankStore.tanks.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _typeNameController.text =
                                                  _requestTypeController.text
                                                              .toLowerCase() ==
                                                          "pump"
                                                      ? pumpStore.pumps[index]
                                                          .displayName
                                                      : tankStore
                                                          .tanks[index].name;
                                            });
                                          },
                                          title: Text(
                                            _requestTypeController.text
                                                        .toLowerCase() ==
                                                    "pump"
                                                ? pumpStore
                                                    .pumps[index].displayName
                                                : tankStore.tanks[index].name,
                                          ),
                                        );
                                      }),
                                ),
                              );
                            });
                      },
                      child: TextField(
                        controller: _typeNameController,
                        enabled: false,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Select ${_requestTypeController.text}",
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: CustomColors.REMIS_PURPLE,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(20),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: CustomColors.REMIS_PURPLE,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: CustomColors.REMIS_PURPLE,
                              )),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                  if(_imageFile != null) {
                    Navigator.of(context).push(
                        LoadingWidget.showLoadingScreen("Uploading Image"));
                    String result = await maintenanceStore.uploadImage(
                        _imageFile.path);
                    Navigator.of(context).pop();
                    if (result == NetworkStrings.SUCCESSFUL) {
                      showDialog(context: context, builder: (_) {
                        return StructuredDialog(
                          giveRadius: true,
                          child: FeedbackWidget(
                            title: "Success",
                            status: true,
                            message: "Image Uploaded",
                          ),);
                      });
                    } else {
                      showDialog(context: context, builder: (_) {
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
                },
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      Constants.getAssetGeneralName("camera", "svg"),
                      color: CustomColors.REMIS_PURPLE,
                      width: 50,
                    ),
                    Text(
                      "Attach Image",
                      style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.REMIS_PURPLE,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            if(_imageFile != null)
              Container(
                height: 200,
                  width: 200,
                  child: Image.file(_imageFile)),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                maxLines: 5,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Descripiton",
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400),
                  isDense: true,
                  contentPadding: EdgeInsets.all(24),
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
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      onPressed: () async {
                          Navigator.of(context).push(LoadingWidget.showLoadingScreen("Recording Maintenance Request"));
                          if(_requestTypeController.text.isNotEmpty && _typeNameController.text.isNotEmpty){
                            String result =
                            await maintenanceStore.submitMaintenanceRequest(
                                _descriptionController.text,
                                _requestTypeController.text,
                                _requestTypeController.text.toLowerCase() ==
                                    "canopy"
                                    ? "Canopy"
                                    : _typeNameController.text,
                                maintenanceStore.imageString);
                            Navigator.of(context).pop();
                            if(result == NetworkStrings.SUCCESSFUL){
                              await showDialog(context: context,builder: (_){
                                return StructuredDialog(
                                  giveRadius: true,
                                  child: FeedbackWidget(
                                    title: "Success",
                                    status: true,
                                    message: "Maintenance request successful added",
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
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      color: CustomColors.REMIS_PURPLE,
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
