import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/db/DBProvider.dart';
import 'package:todoist/model/Task.dart';
import 'package:todoist/model/User.dart';

class CreateTaskPage extends StatefulWidget {
    Task task;
    static String tag = "createTask";
    CreateTaskPage({Key key, @required this.task}) : super(key: key);
    @override
    _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
    String mode;
    int userId;
    static var currentTime = DateTime.now();
    var endDateTxt = TextEditingController(text: convertTime(currentTime));
    var titleTxt = TextEditingController();
    var descrTxt = TextEditingController();
    List<User> responsibleUsers = [];

    @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.task != null){
        mode = "edit";
        fillWIdgets();
    }else{
        mode = "create";
    }
    loadResponsibleUsers();
  }
    @override
    Widget build(BuildContext context) {
        if(widget.task == null){
            widget.task = new Task();
        }
        return Scaffold(
            appBar: AppBar(
                title: Text("Задача"),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.done, color: Colors.white,),
                        onPressed: (){
                            widget.task
                            ..title = titleTxt.text
                            ..descript = descrTxt.text
                            ..endDate = endDateTxt.text
                            ..createDate = convertTime(DateTime.now())
                            ..updateDate = convertTime(DateTime.now())
                            ..creator = userId;

                            if(mode == "create"){
                                DBProvider.db.newTask(widget.task);
                            }else{
                                DBProvider.db.updateTask(widget.task);
                            }

                            Navigator.of(context).pop();
                        },
                    )
                ],
            ),
            body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                children: <Widget>[
                    titleInput(),
                    descriptInput(),
                    endDateInput(),
                    priority(),
                    status(),
                    responsible()
                ],
            )
        );
    }


    titleInput() {
        return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
                controller: titleTxt,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Title',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
            ),
        );
    }

    descriptInput() {
        return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
                controller: descrTxt,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Описание',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
            ),
        );
    }

    endDateInput() {
        return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
                onTap: () {
                    selectDate();
                },
                controller: endDateTxt,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Дата окончания',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
            ),
        );
    }

    priority() {
        return Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 340.0,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)
            ),
            child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                        hint: Text('Приоритет'),
                        value: widget.task.priority,
                        onChanged: (String newValue) {
                            widget.task.priority = newValue;
                            setState(() {});
                        },
                        items: ['Низкий', 'Средний', 'Высокий'].map((
                            String value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                            );
                        }).toList(),
                    ),
                ),
            ),
        );
    }

    status() {
        return Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 340.0,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)
            ),
            child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                        hint: Text("Статус"),
                        value: widget.task.status,
                        onChanged: (String newValue) {
                            widget.task.status = newValue;
                            setState(() {

                            });
                        },
                        items: ['К выполению', 'Выполняется', 'Выполнена', 'Отменена'].map((
                            String value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                            );
                        }).toList(),
                    ),
                ),
            ),
        );
    }

    responsible() {
        return Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 340.0,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)
            ),
            child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                        hint: Text("Ответственный"),
                        value: widget.task.responsibleUser,
                        onChanged: (User newValue) {
                            widget.task.responsible = newValue.id;
                            widget.task.responsibleUser = newValue;
                            setState(() {

                            });
                        },
                        items: responsibleUsers.map((
                            User value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text("${value.lastName} ${value.firstName} ${value.middleName}"),
                            );
                        }).toList(),
                    ),
                ),
            ),
        );
    }



    Future<Null> selectDate() async {
        final DateTime picked = await showDatePicker(
            context: context,
            initialDate: currentTime,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != currentTime) {
            setState(() {
                endDateTxt.text = convertTime(picked);
            });
        }
    }

    loadResponsibleUsers() async{
        await setUserId();
        responsibleUsers = await DBProvider.db.selectResponsibleUsers(userId);
        setState(() {
        });
    }

    static String convertTime(DateTime time){
        return "${time.year}-${time.month}-${time.day}";
    }

     setUserId() async{
        Future<SharedPreferences> futureprefs =  SharedPreferences.getInstance();
        SharedPreferences prefs = await futureprefs;
        userId = prefs.getInt('ID');

    }

    fillWIdgets(){
        Task t = widget.task;
        endDateTxt.text = t.endDate;
        titleTxt.text = t.title;
        descrTxt.text = t.descript;
    }


}
