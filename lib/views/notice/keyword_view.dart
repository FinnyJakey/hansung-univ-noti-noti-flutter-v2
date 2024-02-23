import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/service/cloud_function/keyword_function.dart';
import 'package:hansungunivnotinoti/service/realtime_database/keyword_fetch.dart';

class KeywordView extends StatefulWidget {
  const KeywordView({super.key});

  @override
  State<KeywordView> createState() => _KeywordViewState();
}

class _KeywordViewState extends State<KeywordView> {
  bool initLoaded = false;
  String deviceToken = "";

  List<String> keywords = [];

  TextEditingController textEditingController = TextEditingController();

  bool keywordLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token ?? "";
      getAllMyKeywords(deviceToken: deviceToken).then((fetchedKeywords) {
        setState(() {
          keywords = fetchedKeywords;
          initLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFDDDDDD),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 4,
              width: 35,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "공지사항 키워드",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "키워드가 포함된 공지사항은 앱이 꺼져있어도 푸시알림을 받게 됩니다.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "알림 받을 키워드 (${keywords.length}/20)",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: !initLoaded
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(keywords[index]),
                          const Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: Colors.red[300],
                            ),
                            onPressed: () async {
                              if (keywordLoading) return;

                              setState(() {
                                keywordLoading = true;
                              });

                              await deleteKeyword(keyword: keywords[index], deviceToken: deviceToken);

                              await unsubscribeKeyword(deviceToken: deviceToken, keyword: keywords[index]);

                              List<String> updateKeywords = await getAllMyKeywords(deviceToken: deviceToken);

                              setState(() {
                                keywordLoading = false;
                                keywords = updateKeywords;
                              });
                            },
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(thickness: 0.0);
                    },
                    itemCount: keywords.length,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CupertinoButton(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "키워드 등록하기",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                addKeywordDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  void addKeywordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext statefulContext, void Function(void Function()) statefulSetState) {
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
                      "키워드 등록",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "※ 2글자 이상 10글자 이하",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      "※ 중복 키워드 불가",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      "※ 공백 포함 불가",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                      controller: textEditingController,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      placeholder: '수강신청, 휴학',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              textEditingController.text = "";
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFFF3F3F3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "닫기",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              if (keywordLoading) return;

                              if (textEditingController.text.length < 2 || textEditingController.text.length > 10) {
                                showInvalidDialog();
                                return;
                              }

                              if (textEditingController.text.contains(" ")) {
                                showInvalidDialog();
                                return;
                              }

                              if (keywords.contains(textEditingController.text)) {
                                showInvalidDialog();
                                return;
                              }

                              statefulSetState(() {
                                keywordLoading = true;
                              });

                              await addKeyword(keyword: textEditingController.text, deviceToken: deviceToken);

                              await subscribeKeyword(deviceToken: deviceToken, keyword: textEditingController.text);

                              List<String> updateKeywords = await getAllMyKeywords(deviceToken: deviceToken);

                              setState(() {
                                keywords = updateKeywords;
                                textEditingController.text = "";
                              });

                              statefulSetState(() {
                                keywordLoading = false;
                              });

                              if (statefulContext.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: keywordLoading
                                    ? const CupertinoActivityIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "확인",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showInvalidDialog() {
    showDialog(
      context: context,
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
                  "다시 입력해주세요",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "키워드 규칙을 다시 확인하고 입력해주세요.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
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
                        "확인",
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
