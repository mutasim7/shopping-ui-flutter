// class UserModel {
//   int id;
//   String name;
//   String email;
//   String token;

//   UserModel({required this.id, required this.name, required this.email,required this.token});

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       token: json['token'],
//     );
//   }
// }

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.toObject(json.decode(str));

class UserModel {
  User user;
  String token;

  UserModel({required this.user, required this.token});

  factory UserModel.toObject(Map<String, dynamic> json) => UserModel(
        user: User.toObject(json['user']),
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  int id, currentstate;
  String name;
  String email;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.currentstate});

  factory User.toObject(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      currentstate: json['currentstate']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}





// import 'dart:convert';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));



// class UserModel {
//   User user;
//   String token;

//   UserModel({required this.user, required this.token});

//   factory UserModel.fromJson(Map<String, dynamic> json) =>
//       UserModel(user: User.fromJson(json["user"]), token: json['token']);
// }

// class User {
//   String name;
//   String email;
//   int id;

//   User({required this.name, required this.email, required this.id});

//   factory User.fromJson(Map<String, dynamic> json) =>
//       User(name: json["name"], email: json['email'], id: json['id']);

// Map<String, dynamic> toJson() =>
//     {
//       "name": name,
//       "email": email,
//       "id": id,
//     };



// }
