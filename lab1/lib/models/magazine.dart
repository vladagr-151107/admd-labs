import 'library_item.dart';
import 'user.dart';

class Magazine extends LibraryItem {
  int? issueNumber;
  String? publisher;

  Magazine({required String title, String? author, DateTime? publishDate, User? borrower, DateTime? dueDate, this.issueNumber, this.publisher,})
      : super(title: title, author: author, publishDate: publishDate, borrower: borrower, dueDate: dueDate,
  );
}
