import 'dart:ui';

class NoteModel {
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? editedAt;
  final Color color;

  NoteModel({
    required this.title,
    required this.content,
    required this.createdAt,
    this.editedAt,
    required this.color
  });
}
