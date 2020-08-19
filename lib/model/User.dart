import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
    int id;
    String firstName;
    String lastName;
    String middleName;
    String login;
    String password;
    int managerId;

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.middleName,
        this.login,
        this.password,
        this.managerId,
    });

    factory User.fromMap(Map<String, dynamic> json) =>
        User(
            id: json["id"],
            firstName: json["first_name"],
            lastName: json["last_name"],
            middleName: json["middle_name"],
            login: json["login"],
            password: json["password"],
            managerId: json["manager_id"],
        );

    Map<String, dynamic> toMap() =>
        {
            "id": id,
            "first_name": firstName,
            "last_name": lastName,
            "middle_name": middleName,
            "login": login,
            "password": password,
            "manager_id": managerId,
        };
}
