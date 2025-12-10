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

  bool isLowToHigh = true;

  @override
  void initState() {
    super.initState();
    searchedNotes = widget.notes;
  }

  void sortByCreatedAt() {
    searchedNotes = widget.notes;
    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      searchedNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void sortByUpdatedAt() {
    searchedNotes = widget.notes;

    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.editedAt.compareTo(a.editedAt));
      
    } else {
      searchedNotes.sort((a, b) => a.editedAt.compareTo(b.editedAt));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void sortByTitle() {
    searchedNotes = widget.notes;

    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.title.compareTo(a.title));
      
    } else {
      searchedNotes.sort((a, b) => a.title.compareTo(b.title));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void sortByContent() {
    searchedNotes = widget.notes;

    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.content.compareTo(a.content));
      
    } else {
      searchedNotes.sort((a, b) => a.content.compareTo(b.content));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void openMenu(Size size) {
    showMenu(
      position: RelativeRect.fromLTRB(size.width, 80, 30, size.height),
      context: context,
      items: [
        PopupMenuItem(
          onTap: () {
            sortByCreatedAt();
          },
          child: Text('Sort By Created At'),
        ),
        PopupMenuItem(
          onTap: sortByUpdatedAt,
          child: Text('Sort By Updated At'),
        ),
        PopupMenuItem(onTap: () => sortByTitle(), child: Text('Sort By title')),
        PopupMenuItem(
          onTap: () {
            sortByContent();
          },
          child: Text('Sort By content'),
        ),
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
                      SizedBox(width: 10),
                      Icon(
                        isLowToHigh ? Icons.arrow_downward : Icons.arrow_upward,
                        color: AppColors.white,
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
