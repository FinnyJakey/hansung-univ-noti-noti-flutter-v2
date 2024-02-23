import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hansungunivnotinoti/service/notification/notification_handler.dart';
import 'package:hansungunivnotinoti/service/notification/notification_setup.dart';
import 'package:hansungunivnotinoti/service/realtime_database/version_fetch.dart';
import 'package:hansungunivnotinoti/views/bus/bus_view.dart';
import 'package:hansungunivnotinoti/views/calendar/calendar_view.dart';
import 'package:hansungunivnotinoti/views/food/food_view.dart';
import 'package:hansungunivnotinoti/views/notice/notice_view.dart';
import 'package:hansungunivnotinoti/views/setting/setting_view.dart';
import 'package:hansungunivnotinoti/views/web_view/web_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomTabView extends StatefulWidget {
  const BottomTabView({super.key});

  @override
  State<BottomTabView> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomTabView> {
  final List<String> _tabBarTitleList = ['공지사항', '학사일정', '버스', '학식', '설정'];

  final List<String> _tabBarImageActivePathList = [
    'assets/svg/tab/notice-on.svg',
    'assets/svg/tab/calendar-on.svg',
    'assets/svg/tab/bus-on.svg',
    'assets/svg/tab/food-on.svg',
    'assets/svg/tab/setting-on.svg',
  ];

  final List<String> _tabBarImageInActivePathList = [
    'assets/svg/tab/notice-off.svg',
    'assets/svg/tab/calendar-off.svg',
    'assets/svg/tab/bus-off.svg',
    'assets/svg/tab/food-off.svg',
    'assets/svg/tab/setting-off.svg',
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const NoticeView(),
    const CalendarView(),
    const BusView(),
    const FoodView(),
    const SettingView(),
  ];

  final CupertinoTabController _cupertinoTabController = CupertinoTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      getRequiredUpdate(currentVersion: packageInfo.version).then((value) {
        if (value) {
          showUpdateRequired();
        }
      });
    });

    notificationRequestPermission(context);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(link: initialMessage.data["link"])));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(link: message.data["link"])));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        showAndroidFlutterNotification(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
        activeColor: Colors.black,
        border: const Border(top: BorderSide(color: Color(0xFFD9D9D9), width: 0.0)),
        backgroundColor: Colors.white,
        items: List.generate(_tabBarImageActivePathList.length, (int index) {
          return BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              _tabBarImageActivePathList[index],
              width: 24,
              height: 24,
            ),
            icon: SvgPicture.asset(
              _tabBarImageInActivePathList[index],
              width: 24,
              height: 24,
            ),
            label: _tabBarTitleList[index],
          );
        }),
      ),
      tabBuilder: (context, index) {
        return _widgetOptions[index];
      },
    );
  }

  void showUpdateRequired() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "최신 버전 앱이 필요해요",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "업데이트를 진행해주세요.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      if (await canLaunchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.finnyjakey.hansungunivnotinoti"))) {
                        launchUrl(
                          Uri.parse("https://play.google.com/store/apps/details?id=com.finnyjakey.hansungunivnotinoti"),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }

                    if (Platform.isIOS) {
                      if (await canLaunchUrl(Uri.parse("https://apps.apple.com/app/id6444118912"))) {
                        launchUrl(
                          Uri.parse("https://apps.apple.com/app/id6444118912"),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "업데이트 하러가기",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
