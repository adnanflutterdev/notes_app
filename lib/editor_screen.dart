import 'package:flutter/material.dart';
import 'package:notes/utils/app_colors.dart';
import 'package:notes/utils/notes_color.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void openColorList(TapDownDetails postion) {
      final dx = postion.globalPosition.dx;
      final dy = postion.globalPosition.dy;
      showMenu(
        context: context,

        position: RelativeRect.fromLTRB(dx, 50, 15, dy),
        color: AppColors.surface,
        items: notesColor.map((Color color) {
          return PopupMenuItem(child: Container(height: 40, color: color));
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,

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
                color: notesColor[0],
                shape: BoxShape.circle,
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
                style: TextStyle(
                  fontSize: 30,
                  color: AppColors.textColor,
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
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(
                    fontSize: 20,
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
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.surface,
        shape: CircleBorder(),
        child: Icon(Icons.save, color: Colors.white, size: 30),
      ),
    );
  }
}
