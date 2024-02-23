import 'package:dio/dio.dart';
import 'package:hansungunivnotinoti/service/dio/config.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

Future<Map<String, dynamic>> getFoodForStudent({required String monday}) async {
  try {
    final response = await dio.request(
      "https://www.hansung.ac.kr/diet/hansung/2/view.do",
      data: {
        'monday': monday,
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

    Map<int, Element> elements = document.getElementsByTagName('tbody')[0].getElementsByTagName('tr').asMap();

    List<Map<String, String>> data = [];
    Map<String, String> json = {};

    elements.forEach((index, element) {
      if (index % 2 == 0) {
        json['rice'] = element.getElementsByTagName('td')[1].text;
      } else {
        json['stew'] = element.getElementsByTagName('td')[1].text;
        data.add(json);
        json = {};
      }
    });

    return {"result": true, "data": data};
  } catch (exception) {
    return {"result": false, "data": null};
  }
}

Future<Map<String, dynamic>> getFoodForStaff({required String monday}) async {
  try {
    final response = await dio.request(
      "https://www.hansung.ac.kr/diet/hansung/3/view.do",
      data: {
        'monday': monday,
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

    Map<int, Element> elements = document.getElementsByTagName('tbody')[0].getElementsByTagName('tr').asMap();

    List<String> data = [];

    elements.forEach((index, element) {
      if (index % 2 == 0) {
        data.add(element.getElementsByTagName('td')[1].text);
      }
    });

    return {"result": true, "data": data};
  } catch (exception) {
    return {"result": false, "data": null};
  }
}
