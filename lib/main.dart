import 'package:flutter/material.dart';
import 'db/db_helper.dart';
import 'models/task.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini ToDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _controller = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await dbHelper.getTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> _addTask() async {
    final title = _controller.text;
    if (title.isNotEmpty) {
      await dbHelper.insertTask(Task(title: title));
      _controller.clear();
      _loadTasks();
    }
  }

  Future<void> _deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini ToDo App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nueva tarea',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed:
                      _addTask, // Esto ejecuta la función _addTask al hacer clic en el ícono
                ),
              ),
              onSubmitted:
                  (_) =>
                      _addTask(), // También agrega la tarea cuando presionas enter
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  tasks.isEmpty
                      ? const Text('No hay tareas')
                      : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            onDismissed: (_) => _deleteTask(task.id!),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(title: Text(task.title)),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
