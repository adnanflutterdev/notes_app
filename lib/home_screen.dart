import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:notes/editor_screen.dart';
import 'package:notes/global/my_notes.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/search_screen.dart';
import 'package:notes/utils/app_colors.dart';
import 'package:notes/widgets/all_notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    notes.value = await getNotes();
  }

  void showExitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Exit Note App',
            style: TextStyle(color: AppColors.textColor),
          ),
          content: Text(
            'Are you sure to exit...',
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
                SystemNavigator.pop();
              },
              child: Text('Exit', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showExitDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          title: Text('Notes', style: TextStyle(color: Colors.white)),
          actions: [
            // Search Icon
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(notes: notes.value),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.search, color: AppColors.white),
                ),
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

        body: ValueListenableBuilder(
          valueListenable: notes,
          builder: (context, value, child) {
            if (value.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/no_notes.png'),
                  Text(
                    'Create your first note !',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ],
              );
            } else {
              return AllNotes(notes: value, isHomeScreen: true);
            }
            // return FutureBuilder(
            //   future: getNotes(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return CircularProgressIndicator();
            //     } else if (snapshot.hasError) {
            //       print(snapshot.error);
            //       return Text('Error occured');
            //     } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            //       return
            //     }
            //     notes.value = snapshot.data!;
            //     print(notes.value);
            //     return
            //   },
            // );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditorScreen()),
            );

            // setState(() {});
          },
          backgroundColor: AppColors.surface,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
