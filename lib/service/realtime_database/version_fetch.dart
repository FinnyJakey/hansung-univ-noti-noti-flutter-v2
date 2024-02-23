import 'package:firebase_database/firebase_database.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref("version");

Future<bool> getRequiredUpdate({required String currentVersion}) async {
  DataSnapshot dataSnapshot = await ref.get();
  String requiredVersion = dataSnapshot.value.toString();

  if (int.parse(requiredVersion.split(".")[0]) > int.parse(currentVersion.split(".")[0])) {
    return true;
  }

  if (int.parse(requiredVersion.split(".")[0]) == int.parse(currentVersion.split(".")[0])) {
    if (int.parse(requiredVersion.split(".")[1]) > int.parse(currentVersion.split(".")[1])) {
      return true;
    }

    if (int.parse(requiredVersion.split(".")[1]) == int.parse(currentVersion.split(".")[1])) {
      if (int.parse(requiredVersion.split(".")[2]) > int.parse(currentVersion.split(".")[2])) {
        return true;
      }
    }
  }

  return false;
}
