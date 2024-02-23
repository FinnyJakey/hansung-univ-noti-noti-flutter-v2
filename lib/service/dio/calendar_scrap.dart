import 'package:dio/dio.dart';
import 'package:hansungunivnotinoti/models/calendar_model.dart';
import 'package:hansungunivnotinoti/service/dio/config.dart';
import 'package:hansungunivnotinoti/service/utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

Future<Map<String, dynamic>> getCalendar({required int year}) async {
  try {
    final response = await dio.request(
      "https://www.hansung.ac.kr/schdulmanage/eduinfo/7/yearSchdul.do",
      data: {"year": year},
      options: Options(
        method: 'POST',
        contentType: 'application/x-www-form-urlencoded',
        validateStatus: (status) {
          return status! < 400;
        },
      ),
    );

    Document document = parser.parse(response.toString());

    List<Element> elements = document.getElementsByClassName('yearSchdulWrap');

    List<List<CalendarModel>> data = []; // return 할 데이터

    for (Element element in elements) {
      List<CalendarModel> calendarList = [];

      element.getElementsByClassName('scheList')[0].getElementsByTagName('li').forEach((scheElement) {
        String title = removeWhiteSpace(scheElement.getElementsByTagName('dt')[0].text);
        String content = removeWhiteSpace(scheElement.getElementsByTagName('dd')[0].text);

        calendarList.add(CalendarModel(title: title, content: content));
      });

      data.add(calendarList);
    }

    return {"result": true, "data": data};
  } catch (exception) {
    return {"result": false, "data": null};
  }
}
