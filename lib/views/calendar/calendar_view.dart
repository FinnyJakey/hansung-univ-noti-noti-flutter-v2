import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/calendar_model.dart';
import 'package:hansungunivnotinoti/service/dio/calendar_scrap.dart';
import 'package:hansungunivnotinoti/widgets/calendar/calendar_widget.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  bool initLoaded = false;
  List<List<CalendarModel>> calendars = [];
  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    getCalendar(year: year).then((value) {
      if (value["result"]) {
        setState(() {
          calendars = value["data"];
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
          '학사일정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.left_chevron,
              size: 20,
              color: Color(0xFF666666),
            ),
            onPressed: () {
              setState(() {
                year -= 1;
              });

              getCalendar(year: year).then((value) {
                if (value["result"]) {
                  setState(() {
                    calendars = value["data"];
                  });
                }
              });
            },
          ),
          Text(
            "$year",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.right_chevron,
              size: 20,
              color: Color(0xFF666666),
            ),
            onPressed: () {
              setState(() {
                year += 1;
              });

              getCalendar(year: year).then((value) {
                if (value["result"]) {
                  setState(() {
                    calendars = value["data"];
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
        child: !initLoaded
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoActivityIndicator(),
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return CalendarWidget(year: year, index: index, data: calendars[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(thickness: 0.0);
                },
                itemCount: calendars.length,
              ),
      ),
    );
  }
}
