import 'package:flutter/material.dart';
import 'package:notes/editor_screen.dart';
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(notes: notes),
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
          : AllNotes(notes: notes,isHomeScreen: true,),

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
