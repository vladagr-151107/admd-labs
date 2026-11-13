import 'package:flutter/material.dart';
import '../api/todo_api.dart';
import '../models/todo.dart';

// Change to '/nope' to demo the retry log
const _path = '/todos';

// Task 1
class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;

  const TodoTile({super.key, required this.todo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Checkbox(value: todo.completed, onChanged: (_) => onToggle()),
          Expanded(child: Text(todo.title)),
        ],
      ),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
  var _items = <Todo>[];
  final _input = TextEditingController();

  bool _loading = true;
  Object? _error;
  int _nextId = 1000; // ids for locally added todos

  // used for Bug 3
  String? _filter;

  @override
  void initState() {
    super.initState();

    // Task I check: equal fields -> equal todos
    const a = Todo(userId: 1, id: 1, title: 'x', completed: false);
    const b = Todo(userId: 1, id: 1, title: 'x', completed: false);
    debugPrint('a == b: ${a == b}');

    _load();
  }

  Future<void> _load() async {
    retryLog.value = [];
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final todos = await fetchTodos(path: _path);
      if (!mounted) return;
      setState(() {
        _items = todos;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _add() {
    if (_input.text.trim().isEmpty) return;
    setState(() {
      _items.add(Todo(
        userId: 1,
        id: _nextId++,
        title: _input.text,
        completed: false,
      ));
    });
    _input.clear();
  }

  void _toggle(int i) {
    setState(() {
      _items[i] = _items[i].copyWith(completed: !_items[i].completed);
    });
  }

  // Bug 2 (no setState):
  //void _toggle(int i) => _items[i].done = !_items[i].done;
  // value changes in memory, but is not rebuilt on the screen

  int get _doneCount {
    var done = 0;
    for (var i = 0; i < _items.length; i++) {
      done += _items[i].completed ? 1 : 0;
    }
    // Bug 1 (off-by-one): i <= _items.length.
    // It gives me an error window: valid value range is empty: 0
    return done;
  }

  List<Todo> get _visible {
    if (_filter == null) return _items;
    return _items.where((t) => t.title.contains(_filter!)).toList();
    // Bug 3 (null access): remove the if (_filter == null),
    // then the _filter! crashes while _filter is null.
    // It gives an error: null check operator used on a null value.
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Widget _list(List<Todo> visible) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error', textAlign: TextAlign.center),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final todo = visible[index];
        // Task 2
        return Dismissible(
          key: ValueKey(todo.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            final pos = _items.indexOf(todo);
            setState(() {
              _items.removeWhere((t) => t.id == todo.id);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deleted "${todo.title}"'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => setState(() {
                    _items.insert(pos, todo);
                  }),
                ),
              ),
            );
          },
          background: Container(color: Colors.red),
          child: TodoTile(
            todo: todo,
            onToggle: () => _toggle(_items.indexOf(todo)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos ($_doneCount/${_items.length})'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _input,
              decoration: const InputDecoration(labelText: 'New todo'),
              onSubmitted: (_) => _add(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Filter'),
              onChanged: (v) => setState(() => _filter = v.isEmpty ? null : v),
            ),
          ),
          Expanded(child: _list(visible)),
          // Retry log
          ValueListenableBuilder<List<String>>(
            valueListenable: retryLog,
            builder: (context, log, child) => Container(
              height: 110,
              width: double.infinity,
              color: Colors.black12,
              padding: const EdgeInsets.all(8),
              child: ListView(children: [for (final l in log) Text(l)]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}