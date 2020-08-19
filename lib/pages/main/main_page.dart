import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/pages/create_task/create_task_page.dart';
import 'package:todoist/pages/login/login_page.dart';

import '../../db/DBProvider.dart';
import '../../model/Task.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
    static String tag = 'MainPage';

    MainPage({Key key,}) : super(key: key);
    @override
    _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: appBar(),
            body: body(),
            floatingActionButton: fab(),
        );
    }

    Widget appBar(){
        return AppBar(title: Text("Список задач"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.exit_to_app,color: Colors.white,),
                    onPressed: exit,
                )
            ],
        );
    }

    Widget body(){
        return FutureBuilder<List<Task>>(
            future: DBProvider.db.getAllTasks(),
            builder: (BuildContext context,
                      AsyncSnapshot<List<Task>> snapshot) {
                if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                            Task item = snapshot.data[index];
                            return GestureDetector(
                                onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CreateTaskPage(task: item),
                                        ),
                                    );
                                },
                                child: Dismissible(
                                    key: UniqueKey(),
                                    background: Container(color: Colors.red,),
                                    onDismissed: (direction){
                                        DBProvider.db.deleteTask(item);
                                    },
                                    child: Card(
                                        elevation: 5,
                                        child: Column(
                                            children: <Widget>[
                                                ListTile(
                                                    title: Text(item.title),
                                                    subtitle: Text(item.priority),
                                                ),
                                                Divider(),
                                                ListTile(
                                                    leading: Icon(Icons.date_range),
                                                    title: Text(item.endDate),
                                                ),
                                                ListTile(
                                                    leading: Icon(Icons.account_circle),
                                                    title: Text("${item.lastName} ${item.firstName} ${item.middleName}"),
                                                    subtitle: Text(item.status),
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                            );
                        },
                    );
                } else {
                    return Center(child: CircularProgressIndicator());
                }
            },
        );
    }

    Widget fab(){
        return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
                Navigator.of(context).pushNamed(CreateTaskPage.tag);
            },
        );
    }

    exit()async{
        await forgetUser();
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginPage.tag, (Route<dynamic> route) => false);
    }

    forgetUser() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("ID");
    }
}
