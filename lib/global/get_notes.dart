import 'package:hive/hive.dart';
import 'package:notes/model/note_model.dart';

Future<List<NoteModel>> getNotes() async {
        final db = await Hive.openBox('notes');
        if (db.keys.toList().isEmpty) {
          return [];
        }
        List keys = db.keys.toList();

        List<NoteModel> notes = keys
            .map((id) => NoteModel.fromMap(db.get(id)))
            .toList();
        return notes;
      }