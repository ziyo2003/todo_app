import 'dart:async';

class Repository {
  final StreamController<List<ToDoModel>> _controller = StreamController<List<ToDoModel>>();
  final List<ToDoModel> _todo = [];

  Stream<List<ToDoModel>> get stream async* {
    yield* _controller.stream;
  }

  Future<List<ToDoModel>> getToDo() async {
    final data = _controller.stream;
    return [];
  }

  Future<void> createToDo(String title, String discription) async {
    final newToDo = ToDoModel(
      id: _todo.lastOrNull == null ? 0 : _todo.last.id + 1,
      title: title,
      discription: discription,
    );

    _todo.add(newToDo);

    _controller.add(_todo);
  }
}

class ToDoModel {
  final int id;
  final String title;
  final String discription;


  ToDoModel({required this.id, required this.title, required this.discription});

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is ToDoModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          discription == other.discription;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ discription.hashCode;
}
