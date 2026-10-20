import 'library_item.dart';
import 'user.dart';

class Book extends LibraryItem{
  int? pageCount;
  String? isbn;

  Book({required String title, String? author, DateTime? publishDate, User? borrower, DateTime? dueDate, this.pageCount, this.isbn})
  : super(title: title, author:author, publishDate:publishDate, borrower:borrower, dueDate:dueDate);
}