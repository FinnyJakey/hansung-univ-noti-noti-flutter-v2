import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hansungunivnotinoti/views/notice/keyword_view.dart';
import 'package:hansungunivnotinoti/views/notice/non_subject_list_view.dart';
import 'package:hansungunivnotinoti/views/notice/notice_list_view.dart';
import 'package:hansungunivnotinoti/views/notice/notice_search_view.dart';

class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  bool currentPage = true; // 1: 한성공지, 0: 비교과프로그램

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '공지사항',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: SvgPicture.asset(
              'assets/svg/notice/bell.svg',
              width: 28,
              height: 28,
            ),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * (2 / 3),
                    child: const KeywordView(),
                  );
                },
              );
            },
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: SvgPicture.asset(
              'assets/svg/notice/search.svg',
              width: 28,
              height: 28,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeSearchView()));
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // 한성공지, 비교과 프로그램 버튼
            Row(
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "한성공지",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentPage ? Colors.black : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      currentPage = true;
                    });
                  },
                ),
                const SizedBox(width: 24),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "비교과프로그램",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentPage ? Colors.grey : Colors.black,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      currentPage = false;
                    });
                  },
                ),
              ],
            ),
            currentPage ? const NoticeListView() : const NonSubjectListView(),
          ],
        ),
      ),
    );
  }
}
