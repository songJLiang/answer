//mock.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

class Todo {
  String title = "";

  Todo({required title});

  //工厂类构造方法，将JSON转换为对象
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
    );
  }
}

Future<Todo> fetchTodo(http.Client client) async {
  //获取网络数据
  final response = await client.get('https://xxx.com/todos/1');
  if (response.statusCode == 200) {
    //请求成功，解析JSON
    return Todo.fromJson(json.decode(response.body));
  } else {
    //请求失败，抛出异常
    throw Exception('Failed to load post');
  }
}
