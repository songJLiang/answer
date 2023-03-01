import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'entry/db_helper.dart';
import 'entry/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Answer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: '登录注册'),
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoginForm = false;

  late String username, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_isLoginForm ? "登录" : "注册"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        prefixIcon: Icon(Icons.people),
                        labelText: "Email Address",
                        contentPadding: EdgeInsets.all(0)),
                    onSaved: (value) {
                      username = value!;
                    },
                    validator: (value) {
                      return value!.isEmpty
                          ? 'The email field is required'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        prefixIcon: Icon(Icons.password),
                        labelText: "password",
                        contentPadding: EdgeInsets.all(0)),
                    onSaved: (value) {
                      password = value!;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'The password field is required'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('buttonKey'),
                      onPressed: _submitForm,
                      child: Text(_isLoginForm ? "Login" : "Register",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  TextButton(
                    onPressed: _toggleFormMode,
                    child: Text(_isLoginForm
                        ? 'Don\'t have an account? Create one'
                        : 'Already have an account? Sign in'),
                  ),
                ],
              )),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form?.validate() == true) {
      form?.save();
      if (_isLoginForm) {
        //做登录
        User? user = await DBHelper().queryDatabaseByName(username);
        if (user != null && user.password == password) {
          showToastUI("登录成功");
        }
      } else {
        //做注册
        User curUser = User(username, password);
        int result = await DBHelper().insertUser(curUser);
        if (result > 0) {
          showToastUI("注册成功");
        } else if (result == -1) {
          showToastUI("注册失败，用户名字重复");
        } else {
          showToastUI("注册失败");
        }
      }
    }
  }

  void showToastUI(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
}
