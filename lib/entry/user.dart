class User {
  String name;
  String password;

  User(this.name, this.password);

  ///用于将JSON字典转换成类对象的工厂类方法
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      parsedJson['name'],
      parsedJson['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }
}
