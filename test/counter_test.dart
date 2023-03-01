import 'package:answer/test/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Counter", () {
    //第一个用例，判断Counter对象调用increase方法后是否等于1
    test('Increase a counter value should be 1', () {
      Counter counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });

    //第二个用例，判断1+1是否等于2
    test('Decrease a counter value should be 1', () {
      final counter = Counter();
      counter.decrement();
      expect(counter.value, -1);
    });
  });
}
