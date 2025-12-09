import 'package:flutter/material.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/utils/app_colors.dart';
import 'package:notes/widgets/all_notes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.notes});
  final List<NoteModel> notes;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<NoteModel> searchedNotes = [];

  @override
  void initState() {
    super.initState();
    searchedNotes = widget.notes;
  }

  void openMenu(Size size) {
    showMenu(
      position: RelativeRect.fromLTRB(size.width, 80, 30, size.height),
      context: context,
      items: [
        PopupMenuItem(child: Text('Sort By Crated At')),
        PopupMenuItem(child: Text('Sort By Updated At')),
        PopupMenuItem(child: Text('Sort By title')),
        PopupMenuItem(child: Text('Sort By content')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,

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
      ),
      body: widget.notes.isEmpty
          ? Center(
              child: Text(
                'No Notes Available...',
                style: TextStyle(color: AppColors.textColor),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: AppColors.textColor),
                          decoration: InputDecoration(
                            hintText: 'Search here..',
                            hintStyle: TextStyle(
                              color: AppColors.secondaryTextColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            searchedNotes = widget.notes
                                .where(
                                  (NoteModel note) =>
                                      note.title.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ) ||
                                      note.content.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ),
                                )
                                .toList();
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          openMenu(MediaQuery.of(context).size);
                        },
                        icon: Icon(Icons.sort, color: AppColors.white),
                      ),
                    ],
                  ),

                  Expanded(
                    child: AllNotes(notes: searchedNotes, isHomeScreen: false),
                  ),
                ],
              ),
            ),
    );
  }
}
