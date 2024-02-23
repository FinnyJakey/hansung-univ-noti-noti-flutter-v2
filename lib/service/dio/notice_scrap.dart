import 'package:dio/dio.dart';
import 'package:hansungunivnotinoti/models/notice_model.dart';
import 'package:hansungunivnotinoti/service/dio/config.dart';
import 'package:hansungunivnotinoti/service/utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

Future<Map<String, dynamic>> getNotice({required int page, String searchWord = ""}) async {
  try {
    final response = await dio.request(
      "https://hansung.ac.kr/bbs/hansung/143/artclList.do",
      data: {
        'srchWrd': searchWord,
        'page': page,
        'srchColumn': 'sj',
      },
      options: Options(
        method: 'POST',
        contentType: 'application/x-www-form-urlencoded',
        validateStatus: (status) {
          return status! < 400;
        },
      ),
    );

    Document document = parser.parse(response.toString());

    List<Element> notices = document.getElementsByTagName("tbody").single.getElementsByTagName("tr"); // 공지사항 리스트

    List<NoticeModel> data = []; // return 할 데이터

    for (Element notice in notices) {
      // 블라인드 게시글 체크
      if (removeWhiteSpace(notice.className) == "blind") {
        continue;
      }

      String title = removeWhiteSpace(notice.getElementsByClassName('td-subject')[0].text); // 제목
      String link = "https://hansung.ac.kr${notice.getElementsByTagName('a')[0].attributes['href']!}?layout=unknown"; // 링크
      String writer = removeWhiteSpace(notice.getElementsByClassName('td-write')[0].text); // 글쓴사람
      String date = removeWhiteSpace(notice.getElementsByClassName('td-date')[0].text); // 날짜

      // 상단 고정 체크
      if (removeWhiteSpace(notice.className) == "notice") {
        if (page != 1 || searchWord.isNotEmpty) {
          continue;
        }

        data.add(NoticeModel(title: title, isAnnouncement: true, link: link, writer: writer, date: date));
      } else {
        data.add(NoticeModel(title: title, isAnnouncement: false, link: link, writer: writer, date: date));
      }
    }

    return {"result": true, "data": data};
  } catch (exception) {
    return {"result": false, "data": null};
  }
}
