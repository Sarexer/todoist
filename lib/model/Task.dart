// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

import 'User.dart';

Task taskFromJson(String str) => Task.fromMap(json.decode(str));

String taskToJson(Task data) => json.encode(data.toMap());

class Task {
    int id;
    String title;
    String descript;
    String endDate = "";
    String createDate;
    String updateDate;
    String priority;
    String status = "";
    int creator;
    int responsible;
    User responsibleUser;
    String lastName;
    String firstName;
    String middleName;

    Task({
        this.id,
        this.title,
        this.descript,
        this.endDate,
        this.createDate,
        this.updateDate,
        this.priority,
        this.status,
        this.creator,
        this.responsible,
        this.lastName,
        this.firstName,
        this.middleName
    });

    factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        descript: json["descript"],
        endDate: json["end_date"],
        createDate: json["create_date"],
        updateDate: json["update_date"],
        priority: json["priority"],
        status: json["status"],
        creator: json["creator"],
        responsible: json["responsible"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"]

    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "descript": descript,
        "end_date": endDate,
        "create_date": createDate,
        "update_date": updateDate,
        "priority": priority,
        "status": status,
        "creator": creator,
        "responsible": responsible,
    };




}
