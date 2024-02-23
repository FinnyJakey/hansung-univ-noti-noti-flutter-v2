import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hansungunivnotinoti/widgets/setting/setting_button_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  String deviceToken = "";

  String version = "";

  List<Widget> settingWidgets = [];

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      FirebaseMessaging.instance.getToken().then((value) {
        setState(() {
          deviceToken = value ?? "";

          settingWidgets = [
            SettingButtonWidget(
              title: "현재 버전",
              subtitle: packageInfo.version,
              icon: "info",
              onPressed: () {},
            ),
            SettingButtonWidget(
              title: "디바이스 토큰 복사",
              subtitle: deviceToken,
              icon: "copy",
              onPressed: () {
                Clipboard.setData(ClipboardData(text: deviceToken));
              },
            ),
            SettingButtonWidget(
              title: "개발자에게 문의",
              icon: "headphone",
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse("https://open.kakao.com/o/sHE6ZUrf"))) {
                  launchUrl(
                    Uri.parse("https://open.kakao.com/o/sHE6ZUrf"),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
            SettingButtonWidget(
              title: "개인정보 처리방침",
              icon: "file",
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse("https://blog.naver.com/egel10c_/222916918892"))) {
                  launchUrl(
                    Uri.parse("https://blog.naver.com/egel10c_/222916918892"),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
          ];
        });
      });
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
          '설정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "만든사람",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    foregroundImage: NetworkImage("https://github.com/finnyjakey.png"),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "이윤서",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "학번: 2071249",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "소속: IT융합공학부",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "E-mail: yun9348@naver.com",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "도움 및 지원",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return settingWidgets[index];
                },
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 0.0);
                },
                itemCount: settingWidgets.length,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
