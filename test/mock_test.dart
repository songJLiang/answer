import 'package:answer/test/mock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group("mockTest", () {
    test('如果成功返回一个Todo', () async {
      final client = MockClient();

      //使用Mockito注入请求成功的JSON字段
      when(client.get('https://xxx.com/todos/1'))
          .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

      //验证请求结果是否为Todo实例
      expect(await fetchTodo(client), isInstanceOf<Todo>());
    });

    test('如果失败抛异常', () {
      final client = MockClient();

      //使用Mockito注入请求失败的Error
      when(client.get('https://xxx.com/todos/1'))
          .thenAnswer((_) async => http.Response('Forbidden', 403));

      //验证请求结果是否抛出异常
      expect(fetchTodo(client), throwsException);
    });
  });
}
