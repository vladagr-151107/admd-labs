import 'library_item.dart';
import 'user.dart';

class Book extends LibraryItem{
  int? pageCount;
  String? isbn;

  Book({required super.title, super.author, super.publishDate, super.borrower, super.dueDate, this.pageCount, this.isbn});
}