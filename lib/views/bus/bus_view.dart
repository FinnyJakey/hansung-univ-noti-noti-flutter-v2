import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hansungunivnotinoti/models/bus_model.dart';
import 'package:hansungunivnotinoti/service/dio/bus_fetch.dart';
import 'package:hansungunivnotinoti/service/utils.dart';
import 'package:hansungunivnotinoti/widgets/bus/bus_widget.dart';
import 'package:pull_down_button/pull_down_button.dart';

class BusView extends StatefulWidget {
  const BusView({super.key});

  @override
  State<BusView> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  String title = "성북02";
  int? sliding = 0;
  bool initLoaded = false;

  Timer? _expsTimer;

  List<BusModel> busInfoItems = [];

  List<BusModel> seongBukItems = [];
  List<BusModel> jongNoItems = [];

  @override
  void dispose() {
    super.dispose();
    _expsTimer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    getArrInfoByRouteAll(busRouteId: "107900003").then((value) {
      if (value["result"]) {
        setState(() {
          busInfoItems = value["data"];

          seongBukItems = busInfoItems.sublist(18);

          initLoaded = true;
        });

        _expsTimer?.cancel();
        _expsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            busInfoItems = declineExps(busInfoItems);

            if (title == "성북02") {
              if (sliding == 0) {
                seongBukItems = busInfoItems.sublist(18);
              } else {
                seongBukItems = busInfoItems.sublist(0, 19);
              }
            } else {
              if (sliding == 0) {
                jongNoItems = busInfoItems.sublist(14);
              } else {
                jongNoItems = busInfoItems.sublist(0, 14);
              }
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '마을버스',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                title: '성북02',
                iconWidget: SvgPicture.asset(
                  'assets/svg/tab/bus-off.svg',
                ),
                onTap: () {
                  setState(() {
                    title = "성북02";
                  });

                  getArrInfoByRouteAll(busRouteId: "107900003").then((value) {
                    if (value["result"]) {
                      setState(() {
                        busInfoItems = value["data"];

                        if (sliding == 0) {
                          seongBukItems = busInfoItems.sublist(18);
                        } else {
                          seongBukItems = busInfoItems.sublist(0, 19);
                        }
                      });
                    }
                  });
                },
              ),
              PullDownMenuItem(
                title: '종로03',
                iconWidget: SvgPicture.asset(
                  'assets/svg/tab/bus-off.svg',
                ),
                onTap: () {
                  setState(() {
                    title = "종로03";
                  });

                  getArrInfoByRouteAll(busRouteId: "100900010").then((value) {
                    if (value["result"]) {
                      setState(() {
                        busInfoItems = value["data"];

                        if (sliding == 0) {
                          jongNoItems = busInfoItems.sublist(14);
                        } else {
                          jongNoItems = busInfoItems.sublist(0, 14);
                        }
                      });
                    }
                  });
                },
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onPressed: showMenu,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    size: 16,
                    color: Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: SvgPicture.asset(
              'assets/svg/bus/refresh.svg',
              width: 28,
              height: 28,
            ),
            onPressed: () {
              getArrInfoByRouteAll(busRouteId: title == "성북02" ? "107900003" : "100900010").then((value) {
                if (value["result"]) {
                  setState(() {
                    busInfoItems = value["data"];

                    if (title == "성북02") {
                      if (sliding == 0) {
                        seongBukItems = busInfoItems.sublist(18);
                      } else {
                        seongBukItems = busInfoItems.sublist(0, 19);
                      }
                    } else {
                      if (sliding == 0) {
                        jongNoItems = busInfoItems.sublist(14);
                      } else {
                        jongNoItems = busInfoItems.sublist(0, 14);
                      }
                    }
                  });
                }
              });
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl(
                groupValue: sliding,
                onValueChanged: (value) {
                  setState(() {
                    sliding = value;

                    if (title == "성북02") {
                      if (value == 0) {
                        seongBukItems = busInfoItems.sublist(18);
                      } else {
                        seongBukItems = busInfoItems.sublist(0, 19);
                      }
                    } else {
                      if (value == 0) {
                        jongNoItems = busInfoItems.sublist(14);
                      } else {
                        jongNoItems = busInfoItems.sublist(0, 14);
                      }
                    }
                  });
                },
                children: {
                  0: Text(title == "성북02" ? "한성대정문 도착" : "한성대후문 도착"),
                  1: Text(title == "성북02" ? "한성대정문 출발" : "한성대후문 출발"),
                },
              ),
            ),
            Expanded(
              child: !initLoaded
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CupertinoActivityIndicator(),
                    )
                  : title == "성북02"
                      ? ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BusWidget(arrmsg1: seongBukItems[index].arrmsg1, stNm: seongBukItems[index].stNm, exps1: seongBukItems[index].exps1);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(thickness: 0.0);
                          },
                          itemCount: seongBukItems.length,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BusWidget(arrmsg1: jongNoItems[index].arrmsg1, stNm: jongNoItems[index].stNm, exps1: jongNoItems[index].exps1);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(thickness: 0.0);
                          },
                          itemCount: jongNoItems.length,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
