import 'user.dart';
abstract class LibraryItem {
  String title;
  String? author;
  DateTime? publishDate;
  User? borrower;
  DateTime? dueDate;

  LibraryItem({required this.title, this.author, this.publishDate, this.borrower, this.dueDate});

}