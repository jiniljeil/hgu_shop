import 'package:firebase_database/firebase_database.dart';

class Posts {
  String key;
  String subject;
  String body;
  String name;

  Posts(this.name, this.subject, this.body);

  Posts.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        subject = snapshot.value["subject"],
        name = snapshot.value["name"],
        body = snapshot.value["body"];

  toJson() {
    return {"name": name,"subject": subject, "body": body};
  }
}