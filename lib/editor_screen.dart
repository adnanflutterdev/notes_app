import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes/global/get_notes.dart';
import 'package:notes/global/my_notes.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/utils/app_colors.dart';
import 'package:notes/utils/notes_color.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, this.note});

  final NoteModel? note;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  int bgColorIndex = 0;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      title.text = widget.note!.title;
      content.text = widget.note!.content;
      bgColorIndex = widget.note!.colorIndex;
      print(bgColorIndex);
    }
  }

  void openColorList(TapDownDetails postion) {
    final dx = postion.globalPosition.dx;
    final dy = postion.globalPosition.dy;
    showMenu(
      context: context,

      position: RelativeRect.fromLTRB(dx, 50, 15, dy),
      color: AppColors.surface.withValues(alpha: 0.5),
      items: List.generate(notesColor.length, (index) {
        return PopupMenuItem(
          onTap: () {
            setState(() {
              bgColorIndex = index;
            });
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: notesColor[index],
              border: Border.all(
                color: index == bgColorIndex
                    ? AppColors.activeColor
                    : AppColors.white,
              ),
            ),
          ),
        );
      }),

      //  notesColor.map((Color color) {
      //   return PopupMenuItem(
      //     child: Container(
      //       height: 40,
      //       decoration: BoxDecoration(
      //         color: color,
      //         border: Border.all(color: AppColors.white),
      //       ),
      //     ),
      //   );
      // }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    


    void save() async {
      DateTime dateTime = DateTime.now();
      String id = '${dateTime.microsecondsSinceEpoch}';
      NoteModel note = NoteModel(
        id: widget.note == null ? id : widget.note!.id,
        title: title.text,
        content: content.text,
        // createdAt: DateTime.now(),
        createdAt: widget.note == null ? dateTime : widget.note!.createdAt,
        colorIndex: bgColorIndex,
        editedAt: dateTime,
      );

      final db = await Hive.openBox('notes');

      if (widget.note != null) {
        print(note.toMap());
        db.delete(widget.note!.id);
        await db.put(widget.note!.id, note.toMap());
      } else {
        await db.put(id, note.toMap());
      }
      notes.value = await getNotes();
      

      Navigator.pop(context);
      // Navigator.of(context).pop(note);
    }

    return Scaffold(
      backgroundColor: notesColor[bgColorIndex],
      appBar: AppBar(
        backgroundColor: notesColor[bgColorIndex].withValues(alpha: 0.6),

        elevation: 3,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_back, color: AppColors.white),
              ),
            ),
          ),
        ),

        actions: [
          GestureDetector(
            onTapDown: (postion) {
              openColorList(postion);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: notesColor[bgColorIndex],
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white),
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: TextField(
                maxLines: null,
                controller: title,
                style: TextStyle(
                  fontSize: 30,
                  color: notesColor[bgColorIndex] == AppColors.surface
                      ? AppColors.textColor
                      : AppColors.bg,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    fontSize: 30,
                    color: AppColors.titleTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: content,
                style: TextStyle(
                  fontSize: 20,
                  color: notesColor[bgColorIndex] == AppColors.surface
                      ? AppColors.textColor
                      : AppColors.bg,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: notesColor[bgColorIndex] == AppColors.surface
                        ? AppColors.secondaryTextColor
                        : AppColors.surface,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (content.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please provide content'),
                backgroundColor: AppColors.error,
              ),
            );
          } else {
            save();
          }
        },
        backgroundColor: AppColors.surface,
        shape: CircleBorder(),
        child: Icon(Icons.save, color: Colors.white, size: 30),
      ),
    );
  }
}
