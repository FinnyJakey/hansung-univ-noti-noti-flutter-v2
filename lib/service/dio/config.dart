import 'package:dio/dio.dart';

final Dio dio = Dio(BaseOptions(
  headers: {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
  },
));

const String busServiceKey = "WukqGY1taHLYXMlrEn0dF2hq09uhKT5eYYbajqu%2BlF7Rg9Sy4zu6OXXVWvnFnGl17wxpTRO3BPZ8qlePMTxYyg%3D%3D";
