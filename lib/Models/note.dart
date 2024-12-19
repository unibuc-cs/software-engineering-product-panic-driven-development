import 'model.dart';

class Note implements Model {
  // Data
  int id;
  int mediaId;
  int userId;
  String content;
  DateTime creationDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  Note({
    this.id = -1,
    required this.mediaId,
    required this.userId,
    required this.content
  });

  static String get endpoint => 'notes';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Note).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'content': content,
      'creationdate': creationDate,
      'modifieddate': modifiedDate,
    };
  }

  @override
  factory Note.from(Map<String, dynamic> json) {
    Note note = Note(
      id: json['id'],
      mediaId: json['mediaid'],
      userId: json['userid'],
      content: json['content'],
    );
    note.creationDate = json['creationdate'];
    note.modifiedDate = json['modifieddate'];
    return note;
  }

  // TODO: Endpoint this
  // static Future<List<Note>> getNotes(int userId, int mediaId) async {
  //   return (await Supabase
  //     .instance
  //     .client
  //     .from('note')
  //     .select()
  //     .eq('userid', userId)
  //     .eq('mediaid', mediaId)
  //   ).map(Note.from)
  //    .toList();
  // }
}