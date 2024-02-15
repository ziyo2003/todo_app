import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/repository.dart'; // Make sure this import path matches your project structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Repository repository;

  @override
  void initState() {
    super.initState();
    repository = Repository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _showAddToDoDialog(),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<ToDoModel>>(
        stream: repository.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No todo'));
          }
          final todos = snapshot.data!;
          return ListView.separated(
            itemBuilder: (_, index) => ListTile(
              title: Text(todos[index].title),
              subtitle: Text(todos[index].discription),
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: todos.length,
          );
        },
      ),
    );
  }

  void _showAddToDoDialog() {
    String title = '';
    String description = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (title.isNotEmpty && description.isNotEmpty) {
                  await repository.createToDo(title, description);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
