String databaseName = "db_note";
int databaseVersion = 1;
String tableName = "tbl_word";
String columnId = "id";
String headTitle = "headtitle";
String bodyTitle = "bodytitle";

class NoteModel {
  int id;
  String headtitle;
  String bodytitle;

  NoteModel(
      {this.id = 0,
      this.headtitle = "no headtitle",
      this.bodytitle = "no bodytile"});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[columnId],
      headtitle: map[headTitle],
      bodytitle: map[bodyTitle],
    );
  }

  Map<String, dynamic> get toMap => {
        columnId: id,
        headtitle: headTitle,
        bodytitle: bodyTitle,
      };
}
