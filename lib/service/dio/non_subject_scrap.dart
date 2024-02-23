import 'package:dio/dio.dart';
import 'package:hansungunivnotinoti/models/non_subject_model.dart';
import 'package:hansungunivnotinoti/service/dio/config.dart';
import 'package:hansungunivnotinoti/service/utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

Future<Map<String, dynamic>> getNonSubject({required int page}) async {
  try {
    final response = await dio.request(
      "https://hsportal.hansung.ac.kr/ko/program/all/list/all/$page",
      options: Options(
        method: 'GET',
        validateStatus: (status) {
          return status! < 400;
        },
      ),
    );

    Document document = parser.parse(response.toString());

    List<Element> containers = document.getElementsByClassName('columns-4')[0].getElementsByTagName('li');

    List<NonSubjectModel> data = []; // return 할 데이터

    for (Element container in containers) {
      try {
        String title = container.getElementsByClassName('content')[0].getElementsByTagName('b')[1].text;

        String? cover = container.getElementsByClassName('cover')[0].attributes['style'];
        String? coverUrl = cover == null ? null : "https://hsportal.hansung.ac.kr/attachment/view/${cover.split('/')[3]}/cover.jpg";

        String writer = removeWhiteSpace(container.getElementsByClassName('department')[0].getElementsByClassName("institution")[0].text);

        String link = "https://hsportal.hansung.ac.kr${container.getElementsByTagName('a')[0].attributes['href']}";

        String dateApply = removeWhiteSpace(container.getElementsByClassName('content')[0].getElementsByTagName('small')[2].text);

        String? point;
        if (container.getElementsByTagName('label')[0].nodes.length == 3) {
          point = container.getElementsByTagName('label')[0].nodes[2].text;
        }

        String dayRemain = container.getElementsByTagName('b')[0].text;

        data.add(NonSubjectModel(image: coverUrl, deadline: dayRemain, point: point, writer: writer, title: title, regDate: dateApply, link: link));
      } catch (_) {
        continue;
      }
    }

    return {"result": true, "data": data};
  } catch (exception) {
    return {"result": false, "data": null};
  }
}
