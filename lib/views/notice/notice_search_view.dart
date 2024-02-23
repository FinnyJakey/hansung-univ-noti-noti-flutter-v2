import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hansungunivnotinoti/models/notice_model.dart';
import 'package:hansungunivnotinoti/service/dio/notice_scrap.dart';
import 'package:hansungunivnotinoti/service/utils.dart';
import 'package:hansungunivnotinoti/widgets/notice/notice_widget.dart';

class NoticeSearchView extends StatefulWidget {
  const NoticeSearchView({super.key});

  @override
  State<NoticeSearchView> createState() => _NoticeSearchViewState();
}

class _NoticeSearchViewState extends State<NoticeSearchView> {
  TextEditingController textEditingController = TextEditingController();
  late ScrollController scrollController;

  int page = 1;
  bool extentAfterCalled = false;
  List<NoticeModel> notices = [];

  void _scrollListener() {
    if (scrollController.position.extentAfter < 700 && !extentAfterCalled) {
      extentAfterCalled = true;

      getNotice(page: page++, searchWord: removeWhiteSpace(textEditingController.text)).then((value) {
        if (value["result"]) {
          setState(() {
            notices.addAll(value["data"]);
          });

          extentAfterCalled = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CupertinoTextField(
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(12),
            ),
            controller: textEditingController,
            keyboardType: TextInputType.text,
            autofocus: true,
            prefix: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(
                'assets/svg/notice/search.svg',
                colorFilter: const ColorFilter.mode(Color(0xFF838387), BlendMode.srcIn),
              ),
            ),
            suffix: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                textEditingController.text = "";
              },
              child: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Color(0xFF838387),
              ),
            ),
            placeholder: '수강신청, 휴학',
            onSubmitted: (text) {
              page = 1;

              setState(() {
                notices.clear();
              });

              getNotice(page: page++, searchWord: removeWhiteSpace(text)).then((value) {
                if (value["result"]) {
                  setState(() {
                    notices.addAll(value["data"]);
                  });
                }
              });
            },
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Text(
              "취소",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: ListView.separated(
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return NoticeWidget(
              title: notices[index].title,
              date: notices[index].date,
              writer: notices[index].writer,
              link: notices[index].link,
              isAnnouncement: notices[index].isAnnouncement,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(thickness: 0.0);
          },
          itemCount: notices.length,
        ),
      ),
    );
  }
}
