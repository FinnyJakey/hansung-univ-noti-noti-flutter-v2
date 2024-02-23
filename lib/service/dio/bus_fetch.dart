import 'package:dio/dio.dart';
import 'package:hansungunivnotinoti/models/bus_model.dart';
import 'package:hansungunivnotinoti/service/dio/config.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

Future<dynamic> getArrInfoByRouteAll({required String busRouteId}) async {
  try {
    final response = await dio.request(
      "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRouteAll?serviceKey=$busServiceKey&busRouteId=$busRouteId",
      options: Options(
        method: 'GET',
        validateStatus: (status) {
          return status! < 400;
        },
      ),
    );

    Document document = parser.parse(response.toString());

    List<Element> items = document.getElementsByTagName('itemList');

    List<BusModel> data = [];

    for (Element item in items) {
      data.add(
        BusModel(
          arrmsg1: item.getElementsByTagName("arrmsg1").single.text,
          stNm: item.getElementsByTagName("stNm").single.text,
          exps1: int.parse(item.getElementsByTagName("exps1").single.text),
        ),
      );
    }

    return {"result": true, "data": data};
  } catch (exception) {
    return {"result": false, "data": null};
  }
}
