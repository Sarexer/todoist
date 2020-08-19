import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoist/model/Task.dart';
import 'package:todoist/model/User.dart';

class DBProvider {
    DBProvider._();

    static final DBProvider db = DBProvider._();

    static Database _database;

    Future<Database> get database async {
        if (_database != null)
            return _database;

        // if _database is null we instantiate it

        if(!isDbFileCreated()){
            _database = await initDB();
            insertUsers();
        }else{
            _database = await initDB();
        }
        return _database;
    }

    initDB() async {
        var res = await openDatabase("database.db", version: 1, onOpen: (db) {},
            onCreate: (Database db, int version) async {
                await db.execute("""CREATE TABLE "user" (
          "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
          "first_name"	TEXT NOT NULL,
          "last_name"	TEXT NOT NULL,
          "middle_name"	TEXT,
          "login"	TEXT NOT NULL,
          "password"	TEXT NOT NULL,
          "manager_id"	INTEGER
      )""");

                await db.execute("""CREATE TABLE "task" (
          "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
          "title"	TEXT NOT NULL,
          "descript"	TEXT NOT NULL,
          "end_date"	TEXT NOT NULL,
          "create_date"	TEXT NOT NULL,
          "update_date"	TEXT NOT NULL,
          "priority"	TEXT NOT NULL,
          "status"	TEXT NOT NULL,
          "creator"	INTEGER NOT NULL,
          "responsible"	INTEGER,
          FOREIGN KEY("responsible") REFERENCES "User"("id"),
          FOREIGN KEY("creator") REFERENCES "User"("id")
      )""");
            });


        return res;

    }

    bool isDbFileCreated(){
        return File("/data/user/0/ru.sarexer.todoist/databases/database.db").existsSync();
    }

    insertUsers(){
        List<User> users= [
          User(lastName : "Шмаков", firstName : "Илья", middleName : "Олегович",login: "sarexer", password : "1234" ),
          User(lastName : "Рыболовлев", firstName : "Валерий", middleName : "Сергеевич",login: "valerom", password : "1234",managerId: 1 ),
          User(lastName : "Зубченко", firstName : "Илья", middleName : "Олегович",login: "zubenko", password : "1234", managerId: 1 ),
        ];

        for (var user in users) {
            db.newUser(user);
        }
    }

    newUser(User newUser) async{
        final db = await database;
        var res = await db.insert("user", newUser.toMap());
        return res;
    }

    newTask(Task newTask) async{
        final db = await database;
        var res = await db.insert("task", newTask.toMap());
        return res;
    }

    Future<List<Task>> getAllTasks() async {
        final db = await database;
        var res = await db.rawQuery("select task.id,"
            "title,descript,end_date,create_date,update_date,"
            "priority,status,creator,responsible,"
            "last_name,first_name,middle_name "
            "from task,user where responsible=user.id");
        List<Task> list =
        res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
        return list;
    }

    authentication(String login, String pass) async{
        final db = await database;
        var res =await  db.rawQuery("select * from user where login = '$login' and password = '$pass'");
        return res.isNotEmpty ? User.fromMap(res.first) : Null ;
    }

    selectResponsibleUsers(int id) async{
        final db = await database;
        var res = await db.rawQuery("select * from user where manager_id = $id");
        List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
        return list;
    }

    updateTask(Task newTask) async {
        final db = await database;
        var res = await db.update("task", newTask.toMap(),
            where: "id = ?", whereArgs: [newTask.id]);
        return res;
    }

    deleteTask(Task task)async{
        final db = await database;
        var res = await db.delete("task",
            where: "id = ?", whereArgs: [task.id]);
        return res;
    }
}
