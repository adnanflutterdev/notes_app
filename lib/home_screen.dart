import 'package:flutter/material.dart';
import 'package:notes/editor_screen.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> notes = [];
  void openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Notes App',
            style: TextStyle(color: AppColors.textColor),
          ),
          content: Text(
            'This is my notes app',
            style: TextStyle(color: AppColors.secondaryTextColor),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: AppColors.secondaryTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: Text('Notes', style: TextStyle(color: Colors.white)),
        actions: [
          // Search Icon
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.search, color: AppColors.white),
            ),
          ),
          const SizedBox(width: 15),

          // Info Icon
          GestureDetector(
            onTap: () {
              openDialog();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.info_outline, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),

      body: notes.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/no_notes.png'),
                Text(
                  'Create your first note !',
                  style: TextStyle(color: AppColors.textColor),
                ),
              ],
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                NoteModel note = notes[index];
                DateTime dateTime1 = note.createdAt;
                DateTime? dateTime2 = note.editedAt;
                String time1 =
                    '${dateTime1.hour}:${dateTime1.minute}:${dateTime1.hour >= 12 ? 'PM' : 'AM'}';
                String date =
                    '${dateTime1.day}/${dateTime1.month}/${dateTime1.year}';
                String editedTime = '';
                if (dateTime2 != null) {
                  editedTime =
                      '${dateTime2.day}/${dateTime2.month}/${dateTime2.year}';
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final newNote = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditorScreen(note: note),
                        ),
                      );
                      if (newNote != null) {
                        notes.removeAt(index);
                        notes.insert(index, newNote);
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
                                    color: AppColors.secondaryTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                if (note.editedAt != null)
                                  Text(
                                    'Edited at: $editedTime',
                                    style: TextStyle(
                                      color: AppColors.secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            if (note.title != '')
                              Text(
                                note.title,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              note.content,
                              style: TextStyle(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditorScreen()),
          );

          if (result == null) {
            print('Null');
          } else {
            // notes.add(result);
            // setState(() {
            // });
            setState(() {
              notes.add(result);
            });
          }
        },
        backgroundColor: AppColors.surface,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
