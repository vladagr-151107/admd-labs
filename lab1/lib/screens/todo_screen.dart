import 'package:flutter/material.dart';

class Todo {
  static int _counter = 0;
  final int id = _counter++;
  final String title;
  bool done = false;

  Todo(this.title);
}

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
          Checkbox(value: todo.done, onChanged: (_) => onToggle()),
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
  final _items = <Todo>[];
  final _input = TextEditingController();

  // used for Bug 3
  String? _filter;

  void _add() {
    if (_input.text.trim().isEmpty) return;
    setState(() {
      _items.add(Todo(_input.text));
    });
    _input.clear();
  }

  void _toggle(int i) {
    setState(() {
      _items[i].done = !_items[i].done;
    });
  }

  // Bug 2 (no setState):
  //void _toggle(int i) => _items[i].done = !_items[i].done;
  // It doesn't mark the task done unless you try to toggle it and after that add a new one. It also doesn't untoggle
  // value changes in memory, but is not rebuilt on the screen

  int get _doneCount {
    var done = 0;
    for (var i = 0; i < _items.length; i++) {
      done += _items[i].done ? 1 : 0;
    }
    // Bug 1 (off-by-one): i <= _items.length.
    // It gives me an error window: valid value range is empty: 0
    return done;
  }

  List<Todo> get _visible {
    if (_filter == null) return _items;
    return _items.where((t) => t.title.contains(_filter!)).toList();
    // Bug 3 (null access): remove the "if (_filter == null)" line above,
    // then the _filter! crashes while _filter is null.
    // It gives an error: null check operator used on a null value.
    // Program considers filter full without this condition and crashes
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
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
          Expanded(
            child: ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final todo = visible[index];
                return Dismissible(
                  key: ValueKey(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    final pos = _items.indexOf(todo);
                    setState(() {
                      _items.removeWhere(
                            (t) => t.id == todo.id,
                      );
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