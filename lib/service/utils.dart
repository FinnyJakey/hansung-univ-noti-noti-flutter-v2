import 'package:hansungunivnotinoti/models/bus_model.dart';

String removeWhiteSpace(String str) {
  return str.trim().replaceAll('\n', '').replaceAll('\t', '');
}

String leftTimeConvert(int time) {
  if (time <= 0) {
    return "";
  }

  if (time >= 60) {
    return "${time ~/ 60}분 ${time % 60}초";
  } else {
    return "${time % 60}초";
  }
}

String removeBrackets(String str) {
  RegExp regExp = RegExp(r'\[(.*?)\]');
  Iterable<Match> matches = regExp.allMatches(str);

  if (matches.isNotEmpty) {
    Match match = matches.last;
    String extractedString = match.group(1)!;
    return extractedString;
  }

  return str;
}

declineExps(List<BusModel> busInfoItems) {
  List<BusModel> data = [];

  for (BusModel item in busInfoItems) {
    data.add(BusModel(arrmsg1: item.arrmsg1, stNm: item.stNm, exps1: item.exps1 - 1));
  }

  return data;
}
