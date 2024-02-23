import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/notice_model.dart';
import 'package:hansungunivnotinoti/service/dio/notice_scrap.dart';
import 'package:hansungunivnotinoti/widgets/notice/notice_widget.dart';

class NoticeListView extends StatefulWidget {
  const NoticeListView({super.key});

  @override
  State<NoticeListView> createState() => _NoticeListViewState();
}

class _NoticeListViewState extends State<NoticeListView> {
  late ScrollController scrollController;
  int page = 1;
  bool extentAfterCalled = false;
  bool initLoaded = false;

  List<NoticeModel> notices = [];

  void _scrollListener() {
    if (scrollController.position.extentAfter < 700 && !extentAfterCalled) {
      extentAfterCalled = true;

      getNotice(page: page++).then((value) {
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

    getNotice(page: page++).then((value) {
      if (value["result"]) {
        setState(() {
          notices.addAll(value["data"]);
          initLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !initLoaded
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CupertinoActivityIndicator(),
            )
          : ListView.separated(
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
    );
  }
}
