import 'general/model.dart';

class Note implements Model {
  // Data
  int id;
  int mediaId;
  String userId;
  String content;
  DateTime creationDate;
  DateTime modifiedDate;

  Note({
    this.id = -1,
    required this.mediaId,
    required this.userId,
    required this.content,
    required this.creationDate,
    required this.modifiedDate,
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
      'creationdate': creationDate.toIso8601String(),
      'modifieddate': modifiedDate.toIso8601String(),
    };
  }

  @override
  factory Note.from(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      mediaId: json['mediaid'],
      userId: json['userid'],
      content: json['content'],
      creationDate: DateTime.parse(json['creationdate']),
      modifiedDate: DateTime.parse(json['modifieddate']),
    );
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