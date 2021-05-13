import 'package:epump/screens/companydashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/companystores/companysalesstore.dart';
import 'package:epump/utils/company/mybranches.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyBranches extends StatefulWidget {
  @override
  _CompanyBranchesState createState() => _CompanyBranchesState();
}

class _CompanyBranchesState extends State<CompanyBranches> {
  bool showFilter = false;
  bool isDataFetched = false;
  List<MyBranches> filteredBranches = [];
  TextEditingController _filterController = TextEditingController();

  void filterBranches(String text) {
    final companyStore = Provider.of<CompanySalesStore>(context, listen: false);
    filteredBranches.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    companyStore.branches.forEach((branch) {
      if (branch.name.toLowerCase().contains(text.toLowerCase())) {
        filteredBranches.add(branch);
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyStore = Provider.of<CompanySalesStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isDataFetched) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Branches"));
        await companyStore.getBranches();
        Navigator.of(context).pop();
        setState(() {
          isDataFetched = true;
        });
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: !showFilter
                ? Text("Branches")
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                    top: 5,
                                    bottom: 5,
                                    left: 3,
                                    child: Icon(
                                      Icons.search,
                                      color: CustomColors.REMIS_PURPLE,
                                      size: 20,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: TextField(
                                    controller: _filterController,
                                    onChanged: filterBranches,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: CustomColors.REMIS_PURPLE),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Filter",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.REMIS_PURPLE),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    showFilter = !showFilter;
                  });
                }),
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                color: CustomColors.REMIS_PURPLE,
                onSelected: (value) {
                  if (filteredBranches.length != 0 &&
                      _filterController.text.isNotEmpty) {
                    if (value == "PMS") {
                      filteredBranches.sort((a, b) =>
                          a.pmsTotalVolume.compareTo(b.pmsTotalVolume));
                    } else if (value == "DPK") {
                      filteredBranches.sort((a, b) =>
                          a.dpkTotalVolume.compareTo(b.dpkTotalVolume));
                    } else {
                      filteredBranches.sort((a, b) =>
                          a.agoTotalVolume.compareTo(b.agoTotalVolume));
                    }
                    setState(() {});
                  } else {
                    if (value == "PMS") {
                      companyStore.sortBranches("PMS");
                    } else if (value == "DPK") {
                      companyStore.sortBranches("DPK");
                    } else if(value == "AGO") {
                      companyStore.sortBranches("AGO");
                    }else if(value == "LPG") {
                      companyStore.sortBranches("LPG");
                    }
                    // setState(() {
                    // });
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: "AGO",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sort By AGO Volume",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                    PopupMenuItem(
                        value: "DPK",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sort By DPK Volume",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                    PopupMenuItem(
                        value: "PMS",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sort By PMS Volume",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                    PopupMenuItem(
                        value: "LPG",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sort By LPG Volume",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ];
                })
          ],
        ),
        drawer: CompanyDrawerOnly(),
        body: filteredBranches.length != 0 && _filterController.text.isNotEmpty
            ? ListView.builder(
                itemCount: filteredBranches.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "LOCATION", filteredBranches[index].name);
                      NetworkRequest.BRANCHID =
                          filteredBranches[index].branchId;
                      Navigator.of(context).pushNamed("/dashboard", arguments: {
                        "location": filteredBranches[index].name,
                        "isCompany": true
                      });
                    },
                    child: CustomListCard(
                      name: filteredBranches[index].name,
                      pmsVolume: Constants.formatThisInput(
                          filteredBranches[index].pmsTotalVolume),
                      agoVolume: Constants.formatThisInput(
                          filteredBranches[index].agoTotalVolume),
                      dpkVolume: Constants.formatThisInput(
                          filteredBranches[index].dpkTotalVolume),
                      location:
                          "${filteredBranches[index].city} ${filteredBranches[index].state}",
                    ),
                  );
                })
            : Observer(
                builder: (_) => ListView.builder(
                    itemCount: companyStore.branches.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setString(
                              "LOCATION", companyStore.branches[index].name);
                          NetworkRequest.BRANCHID =
                              companyStore.branches[index].branchId;
                          Navigator.of(context).pushNamed("/dashboard",
                              arguments: {
                                "location": companyStore.branches[index].name,
                                "isCompany": true
                              });
                        },
                        child: CustomListCard(
                          name: companyStore.branches[index].name,
                          pmsVolume: Constants.formatThisInput(
                              companyStore.branches[index].pmsTotalVolume),
                          agoVolume: Constants.formatThisInput(
                              companyStore.branches[index].agoTotalVolume),
                          dpkVolume: Constants.formatThisInput(
                              companyStore.branches[index].dpkTotalVolume),
                          location:
                              "${companyStore.branches[index].city} ${companyStore.branches[index].state}",
                        ),
                      );
                    }),
              ));
  }
}

class CustomListCard extends StatelessWidget {
  final name;
  final pmsVolume;
  final location;
  final agoVolume;
  final dpkVolume;

  CustomListCard(
      {this.name,
      this.pmsVolume,
      this.location,
      this.agoVolume,
      this.dpkVolume});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CustomColors.REMIS_LIGHT_GREY),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 17.0, vertical: 15.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.business,
                  size: 50,
                  color: CustomColors.REMIS_DARK_PURPLE,
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
                        "$name",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        location,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "PMS Volume: $pmsVolume ltr(s)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "AGO Volume: $agoVolume ltr(s)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "DPK Volume: $dpkVolume ltr(s)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
