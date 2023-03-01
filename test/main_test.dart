import 'package:answer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('测试登录注册ui', (WidgetTester tester) async {
    ///声明所需要验证的Widget == MyApp，并触发其渲染
    await tester.pumpWidget(const MyApp());

    /// 查找字符串文本为'登录注册'的Widget，验证查找失败
    expect(find.widgetWithText(Text,'登录注册'), findsNothing);

    /// 查找到 登录/注册 按钮，并触发他的点击行为
    await tester.tap(find.byKey(const ValueKey('buttonKey')));

    /// 触发其渲染
    // await tester.pump();
  });
}
