import 'general/service.dart';
import '../Models/note.dart';

class NoteService extends Service<Note> {
  NoteService() : super(Note.endpoint, Note.from);
}
