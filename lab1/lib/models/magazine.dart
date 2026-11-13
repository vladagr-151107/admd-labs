import 'library_item.dart';
import 'user.dart';

class Magazine extends LibraryItem {
  int? issueNumber;
  String? publisher;

  Magazine({required super.title, super.author, super.publishDate, super.borrower, super.dueDate, this.issueNumber, this.publisher,});
}
