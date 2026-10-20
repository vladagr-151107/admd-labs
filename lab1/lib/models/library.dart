import 'library_item.dart';
import 'user.dart';

class Library {
  List<LibraryItem> items = [];

  bool addItem(LibraryItem item) {
    if (item.title.trim().isEmpty) {
      return false;
    }

    items.add(item);
    return true;
  }

  List<LibraryItem> searchByTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return [];
    }

    return items.where((item) =>
        item.title.toLowerCase().contains(title.toLowerCase())).toList();
  }

  List<LibraryItem> getItemsByAuthor(String? author) {
    if (author == null || author.trim().isEmpty) {
      return [];
    }

    return items.where((item) =>
    item.author?.toLowerCase() == author.toLowerCase()).toList();
  }

  List<LibraryItem> getRecentItems() {
    DateTime oneYearAgo =
    DateTime.now().subtract(const Duration(days: 365));

    return items.where((item) =>
    item.publishDate != null &&
        item.publishDate!.isAfter(oneYearAgo)).toList();
  }

  bool borrowItem(
      LibraryItem item, User user, DateTime dueDate) {
    if (!items.contains(item) || item.borrower != null) {
      return false;
    }

    item.borrower = user;
    item.dueDate = dueDate;
    return true;
  }

  bool returnItem(LibraryItem item) {
    if (!items.contains(item) || item.borrower == null) {
      return false;
    }

    item.borrower = null;
    item.dueDate = null;
    return true;
  }
}
