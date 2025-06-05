class Task {
  final int? id;
  final String title;

  Task({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
    );
  }
}


// class Task {
//   final int? id;
//   final String title;
//   bool isCompleted;

//   Task({this.id, required this.title, this.isCompleted = false});

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'isCompleted': isCompleted ? 1 : 0, // Convertimos bool a int (1 para completada, 0 para no)
//     };
//   }

//   factory Task.fromMap(Map<String, dynamic> map) {
//     return Task(
//       id: map['id'],
//       title: map['title'],
//       isCompleted: map['isCompleted'] == 1,  // Convertimos 1 a true y 0 a false
//     );
//   }
// }
