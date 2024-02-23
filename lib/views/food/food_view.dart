import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hansungunivnotinoti/service/dio/food_scrap.dart';
import 'package:hansungunivnotinoti/widgets/food/food_staff_widget.dart';
import 'package:hansungunivnotinoti/widgets/food/food_student_widget.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  String title = "학생식당";
  int? sliding = 0;

  bool initLoaded = false;

  List<Map<String, String>> student = [];
  List<String> staff = [];

  final DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    sliding = currentDate.weekday - 1;

    String monday = DateFormat("yyyy.MM.dd").format(currentDate.subtract(Duration(days: currentDate.weekday - 1)));

    getFoodForStudent(monday: monday).then((value) {
      if (value["result"]) {
        setState(() {
          student = value["data"];
          initLoaded = true;
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
          '학식',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                title: '학생식당',
                iconWidget: SvgPicture.asset(
                  'assets/svg/food/pizza.svg',
                ),
                onTap: () {
                  String monday = DateFormat("yyyy.MM.dd").format(currentDate.subtract(Duration(days: currentDate.weekday - 1)));

                  getFoodForStudent(monday: monday).then((value) {
                    if (value["result"]) {
                      setState(() {
                        title = "학생식당";
                        student = value["data"];
                      });
                    }
                  });
                },
              ),
              PullDownMenuItem(
                title: '교직원식당',
                iconWidget: SvgPicture.asset(
                  'assets/svg/food/cake.svg',
                ),
                onTap: () {
                  String monday = DateFormat("yyyy.MM.dd").format(currentDate.subtract(Duration(days: currentDate.weekday - 1)));

                  getFoodForStaff(monday: monday).then((value) {
                    if (value["result"]) {
                      setState(() {
                        title = "교직원식당";
                        staff = value["data"];
                      });
                    }
                  });
                },
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              // padding: EdgeInsets.zero,
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
                  });
                },
                children: const {
                  0: Text("월"),
                  1: Text("화"),
                  2: Text("수"),
                  3: Text("목"),
                  4: Text("금"),
                  5: Text("토"),
                  6: Text("일"),
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
                  : title == "학생식당"
                      ? FoodStudentWidget(
                          date: DateFormat("yyyy.MM.dd (EEE)").format(currentDate.subtract(Duration(days: currentDate.weekday - (sliding! + 1)))),
                          rice: student[sliding!]["rice"]!,
                          stew: student[sliding!]["stew"]!,
                        )
                      : FoodStaffWidget(
                          date: DateFormat("yyyy.MM.dd (EEE)").format(currentDate.subtract(Duration(days: currentDate.weekday - (sliding! + 1)))),
                          rice: staff[sliding!],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
