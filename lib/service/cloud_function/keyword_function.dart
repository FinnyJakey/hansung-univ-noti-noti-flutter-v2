import 'package:cloud_functions/cloud_functions.dart';

FirebaseFunctions functions = FirebaseFunctions.instance;

Future<bool> subscribeKeyword({required String deviceToken, required String keyword}) async {
  HttpsCallable callable = functions.httpsCallable('subscribeKeyword');
  final results = await callable.call({"deviceToken": deviceToken, "keyword": Uri.encodeFull(keyword)});
  return (results.data);
}

Future<bool> unsubscribeKeyword({required String deviceToken, required String keyword}) async {
  HttpsCallable callable = functions.httpsCallable('unsubscribeKeyword');
  final results = await callable.call({"deviceToken": deviceToken, "keyword": Uri.encodeFull(keyword)});
  return (results.data);
}

Future<bool> sendMessage({required String keyword, required String message}) async {
  HttpsCallable callable = functions.httpsCallable('sendMessage');
  final results = await callable.call({"keyword": keyword, "message": message});
  return (results.data);
}
