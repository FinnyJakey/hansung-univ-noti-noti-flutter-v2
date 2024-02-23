import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/non_subject_model.dart';
import 'package:hansungunivnotinoti/service/dio/non_subject_scrap.dart';
import 'package:hansungunivnotinoti/widgets/notice/non_subject_widget.dart';

class NonSubjectListView extends StatefulWidget {
  const NonSubjectListView({super.key});

  @override
  State<NonSubjectListView> createState() => _NonSubjectListViewState();
}

class _NonSubjectListViewState extends State<NonSubjectListView> {
  late ScrollController scrollController;
  int page = 1;
  bool extentAfterCalled = false;
  bool initLoaded = false;

  List<NonSubjectModel> nonSubjects = [];

  void _scrollListener() {
    if (scrollController.position.extentAfter < 300 && !extentAfterCalled) {
      extentAfterCalled = true;

      getNonSubject(page: page++).then((value) {
        if (value["result"]) {
          setState(() {
            nonSubjects.addAll(value["data"]);
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

    getNonSubject(page: page++).then((value) {
      if (value["result"]) {
        setState(() {
          nonSubjects.addAll(value["data"]);
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
          : GridView.builder(
              controller: scrollController,
              itemCount: nonSubjects.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                childAspectRatio: 3 / 4, //item 의 가로 2, 세로 3 의 비율
                mainAxisSpacing: 6, //수평 Padding
                crossAxisSpacing: 10, //수직 Padding
              ),
              itemBuilder: (context, index) {
                return NonSubjectWidget(
                  image: nonSubjects[index].image,
                  deadline: nonSubjects[index].deadline,
                  point: nonSubjects[index].point,
                  writer: nonSubjects[index].writer,
                  title: nonSubjects[index].title,
                  regDate: nonSubjects[index].regDate,
                  link: nonSubjects[index].link,
                );
              },
            ),
    );
  }
}
