class Note{
  String title;

  Note(this.title);

  Note.fromJson(Map<String, dynamic> json){
    title = json["title"];
  }
}