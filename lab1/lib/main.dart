import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/library.dart';
import 'models/library_item.dart';
import 'models/book.dart';
import 'models/magazine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// StatefulWidget is needed so the screen can update after Borrow/Return
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<User> users = [
    User(name: 'Anna', age: 20, email: 'anna@gmail.com'),
    User(name: 'Maria', age: 22),
    User(name: 'John'),
  ];

  final List<BankAccount> accounts = [
    BankAccount(holderName: 'Anna', balance: 100.0, bankBranch: 'Bucharest')
      ..initializeAccount('12345'),
    BankAccount(holderName: 'Maria', bankBranch: 'Cluj')
      ..initializeAccount('67890'),
    BankAccount(holderName: 'John'), // account number is not initialized
  ];

  final Library library = Library();

  // Text from the search field
  String query = '';

  @override
  void initState() {
    super.initState();

    library.addItem(Book(
      title: 'Harry Potter',
      author: 'J. K. Rowling',
      pageCount: 350,
      isbn: '123456',
      publishDate: DateTime(2025, 5, 10),
    ));

    library.addItem(Magazine(
      title: 'Science Today',
      issueNumber: 12,
      publisher: 'Science Press',
      publishDate: DateTime(2026, 3, 15),
    ));

    library.addItem(Book(title: 'Dart Basics'));
  }

  // Borrow the item as Anna (first user)
  void borrow(LibraryItem item) {
    bool ok = library.borrowItem(
      item,
      users[0],
      DateTime.now().add(const Duration(days: 14)),
    );
    setState(() {}); // refresh the screen
    showMessage(ok ? 'Borrowed by Anna' : 'Already borrowed');
  }

  void giveBack(LibraryItem item) {
    bool ok = library.returnItem(item);
    setState(() {});
    showMessage(ok ? 'Item returned' : 'Item is not borrowed');
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  // Builds the text under the item title
  String itemInfo(LibraryItem item) {
    String text = '';

    if (item is Book) {
      text += 'Book\n';
    } else if (item is Magazine) {
      text += 'Magazine\n';
    }

    text += 'Author: ${item.author ?? 'N/A'}\n';
    text += 'Published: ${item.publishDate?.toString().split(' ')[0] ?? 'N/A'}\n';

    // "is Book" lets us use pageCount and isbn
    if (item is Book) {
      text += 'Pages: ${item.pageCount ?? 'N/A'}\n';
      text += 'ISBN: ${item.isbn ?? 'N/A'}\n';
    }

    if (item is Magazine) {
      text += 'Issue: ${item.issueNumber ?? 'N/A'}\n';
      text += 'Publisher: ${item.publisher ?? 'N/A'}\n';
    }

    text += 'Borrower: ${item.borrower?.name ?? 'Available'}\n';
    text += 'Due date: ${item.dueDate?.toString().split(' ')[0] ?? 'N/A'}';

    return text;
  }

  // Shows Return button if borrowed, otherwise Borrow button
  Widget borrowButton(LibraryItem item) {
    if (item.borrower != null) {
      return ElevatedButton(
        onPressed: () => giveBack(item),
        child: const Text('Return'),
      );
    }
    return ElevatedButton(
      onPressed: () => borrow(item),
      child: const Text('Borrow'),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If search is empty show everything, otherwise use searchByTitle
    List<LibraryItem> shownItems = library.items;
    if (query.trim().isNotEmpty) {
      shownItems = library.searchByTitle(query);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 2')),
      body: ListView(
        children: [
          // TASK I
          sectionTitle('Users'),
          for (final user in users)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(user.name),
              subtitle: Text(
                'Age: ${user.getDisplayAge()}\n'
                    'Email: ${user.email ?? 'Not provided'}',
              ),
            ),

          // TASK II
          sectionTitle('Bank accounts'),
          for (final account in accounts)
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: Text(account.holderName),
              subtitle: Text(
                'Account: ${account.isAccountNumberSet() ? account.accountNumber.toString() : 'Account number not initialized'}\n'
                    'Balance: ${account.balance}\n'
                    'Branch: ${account.bankBranch ?? 'N/A'}',
              ),
            ),

          // TASK III
          sectionTitle('Library'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by title',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          for (final item in shownItems)
            ListTile(
              leading: Icon(item is Book ? Icons.menu_book : Icons.article),
              title: Text(item.title),
              subtitle: Text(itemInfo(item)),
              trailing: borrowButton(item),
            ),
          if (shownItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No items found'),
            ),
        ],
      ),
    );
  }
}