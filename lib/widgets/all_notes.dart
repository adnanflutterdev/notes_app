import 'package:flutter/material.dart';
import 'package:notes/editor_screen.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/utils/app_colors.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key, required this.notes, required this.isHomeScreen});
  final List<NoteModel> notes;
  final bool isHomeScreen;

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  @override
  Widget build(BuildContext context) {
    void showDeleteDialog(int index) {
      showDialog(
        context: context,
        builder: (context) {
          NoteModel deletedNote = widget.notes[index];
          return AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              'Deleting note',
              style: TextStyle(color: AppColors.textColor),
            ),
            content: Text(
              'Are you sure to delete this note',
              style: TextStyle(color: AppColors.secondaryTextColor),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.notes.removeAt(index);
                  Navigator.pop(context);
                  setState(() {});

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Note Deleted...'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          widget.notes.insert(index, deletedNote);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        NoteModel note = widget.notes[index];

        DateTime dateTime1 = note.createdAt;

        DateTime dateTime2 = note.editedAt;

        String time1 =
            '${dateTime1.hour}:${dateTime1.minute}:${dateTime1.second} ${dateTime1.hour >= 12 ? 'PM' : 'AM'}';
        String date = '${dateTime1.day}/${dateTime1.month}/${dateTime1.year}';

        String editedDate = '';
        String editedTime = '';

        if (dateTime2 == dateTime1) {
          print('Both are equal');
        }

        if (dateTime1 != dateTime2) {
          editedDate = '${dateTime2.day}/${dateTime2.month}/${dateTime2.year}';
          editedTime =
              '${dateTime2.hour}:${dateTime2.minute}:${dateTime2.second} ${dateTime2.hour >= 12 ? 'PM' : 'AM'}';
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GestureDetector(
            onTap: () async {
              final newNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorScreen(note: note),
                ),
              );
              if (newNote != null) {
                // notes.removeAt(index);
                // notes.insert(index, newNote);

                widget.notes[index] = newNote;
                setState(() {});
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: note.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$time1 $date",
                          style: TextStyle(
                            color: note.color == AppColors.surface
                                ? AppColors.secondaryTextColor
                                : AppColors.surface,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        if (widget.isHomeScreen)
                          InkWell(
                            onTap: () {
                              showDeleteDialog(index);
                            },
                            child: Icon(Icons.delete, color: AppColors.error),
                          ),
                      ],
                    ),
                    if (note.title != '')
                      Text(
                        note.title,
                        style: TextStyle(
                          color: note.color == AppColors.surface
                              ? AppColors.textColor
                              : AppColors.bg,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Text(
                      note.content,
                      style: TextStyle(
                        color: note.color == AppColors.surface
                            ? AppColors.textColor
                            : AppColors.bg,
                      ),
                    ),
                    if (note.editedAt != note.createdAt)
                      Text(
                        'Edited at: $editedTime $editedDate',
                        style: TextStyle(
                          color: note.color == AppColors.surface
                              ? AppColors.secondaryTextColor
                              : AppColors.surface,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
