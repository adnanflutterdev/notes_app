import 'dart:ui';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime editedAt;
  final int colorIndex;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.editedAt,
    required this.colorIndex,
  });

  Map toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'editedAt': editedAt,
      'colorIndex': colorIndex,
    };
  }

  factory NoteModel.fromMap(Map note) {
    return NoteModel(
      id: note['id'],
      title: note['title'],
      content: note['content'],
      createdAt: note['createdAt'],
      editedAt: note['editedAt'],
      colorIndex: note['colorIndex'],
    );
  }
}
