import 'package:flutter/material.dart';
import 'package:notes/global/my_notes.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/utils/app_colors.dart';
import 'package:notes/utils/notes_color.dart';
import 'package:notes/widgets/all_notes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  // final List<NoteModel> notes;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<NoteModel> searchedNotes = [];

  bool isLowToHigh = true;

  @override
  void initState() {
    super.initState();
    searchedNotes = notes.value;
  }

  void sortByCreatedAt() {
    searchedNotes = notes.value;
    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      searchedNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void sortByUpdatedAt() {
    searchedNotes = notes.value;

    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.editedAt.compareTo(a.editedAt));
    } else {
      searchedNotes.sort((a, b) => a.editedAt.compareTo(b.editedAt));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void sortByTitle() {
    searchedNotes = notes.value;

    if (isLowToHigh) {
      searchedNotes.sort((a, b) => b.title.compareTo(a.title));
    } else {
      searchedNotes.sort((a, b) => a.title.compareTo(b.title));
    }
    isLowToHigh = !isLowToHigh;
    setState(() {});
  }

  void sortByContent() {
    searchedNotes = notes.value;

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
      body: notes.value.isEmpty
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
                            print(value);
                            searchedNotes = notes.value
                                .where(
                                  (NoteModel note) =>
                                      note.title.toLowerCase().contains(
                                        value.trim().toLowerCase(),
                                      ) ||
                                      note.content.toLowerCase().contains(
                                        value.trim().toLowerCase(),
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
                    child: ListView.builder(
                      itemCount: searchedNotes.length,
                      itemBuilder: (context, index) {
                        NoteModel note = searchedNotes[index];
                        DateTime dateTime1 = note.createdAt;

                        DateTime dateTime2 = note.editedAt;

                        String time1 =
                            '${dateTime1.hour}:${dateTime1.minute}:${dateTime1.second} ${dateTime1.hour >= 12 ? 'PM' : 'AM'}';
                        String date =
                            '${dateTime1.day}/${dateTime1.month}/${dateTime1.year}';

                        String editedDate = '';
                        String editedTime = '';

                        if (dateTime2 == dateTime1) {
                          print('Both are equal');
                        }

                        if (dateTime1 != dateTime2) {
                          editedDate =
                              '${dateTime2.day}/${dateTime2.month}/${dateTime2.year}';
                          editedTime =
                              '${dateTime2.hour}:${dateTime2.minute}:${dateTime2.second} ${dateTime2.hour >= 12 ? 'PM' : 'AM'}';
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: notesColor[note.colorIndex],
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
                                          color:
                                              notesColor[note.colorIndex] ==
                                                  AppColors.surface
                                              ? AppColors.secondaryTextColor
                                              : AppColors.surface,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (note.title != '')
                                    Text(
                                      note.title,
                                      style: TextStyle(
                                        color:
                                            notesColor[note.colorIndex] ==
                                                AppColors.surface
                                            ? AppColors.textColor
                                            : AppColors.bg,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Text(
                                    note.content,
                                    style: TextStyle(
                                      color:
                                          notesColor[note.colorIndex] ==
                                              AppColors.surface
                                          ? AppColors.textColor
                                          : AppColors.bg,
                                    ),
                                  ),
                                  if (note.editedAt != note.createdAt)
                                    Text(
                                      'Edited at: $editedTime $editedDate',
                                      style: TextStyle(
                                        color:
                                            notesColor[note.colorIndex] ==
                                                AppColors.surface
                                            ? AppColors.secondaryTextColor
                                            : AppColors.surface,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Expanded(child: AllNotes(isHomeScreen: false)),
                ],
              ),
            ),
    );
  }
}
