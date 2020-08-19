import 'package:flutter/material.dart';
import 'package:todoist/pages/create_task/create_task_page.dart';
import 'package:todoist/pages/login/login_page.dart';
import 'package:todoist/pages/main/main_page.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {

        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            routes: <String,WidgetBuilder>{
                LoginPage.tag : (BuildContext context) => LoginPage(),
                MainPage.tag : (BuildContext context) => MainPage(),
                CreateTaskPage.tag : (BuildContext context) => CreateTaskPage()
            },

            initialRoute: LoginPage.tag,
        );
    }
}
