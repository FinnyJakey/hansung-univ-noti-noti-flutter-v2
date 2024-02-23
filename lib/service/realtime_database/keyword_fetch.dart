import 'package:firebase_database/firebase_database.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref("KeyWords");

Future<List<String>> getAllMyKeywords({required String deviceToken}) async {
  DataSnapshot dataSnapshot = await ref.get();
  Map keywords = dataSnapshot.value as Map;

  List<String> data = [];

  keywords.forEach((keyword, value) {
    Map tokenData = value as Map;

    tokenData.forEach((token, value) {
      if (token == deviceToken) {
        data.add(keyword);
      }
    });
  });

  return data;
}

Future<void> addKeyword({required String keyword, required String deviceToken}) async {
  DataSnapshot dataSnapshot = await ref.get();
  await dataSnapshot.child(keyword).ref.update({deviceToken: keyword});
}

Future<void> deleteKeyword({required String keyword, required String deviceToken}) async {
  DataSnapshot dataSnapshot = await ref.get();
  await dataSnapshot.child(keyword).child(deviceToken).ref.remove();
}
