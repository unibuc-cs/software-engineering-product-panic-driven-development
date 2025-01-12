import 'general/service.dart';
import '../Models/note.dart';

class NoteService extends Service<Note> {
  NoteService._() : super(Note.endpoint, Note.from);
  
  static final NoteService _instance = NoteService._();

  static NoteService get instance => _instance;
}
