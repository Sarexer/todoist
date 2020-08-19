import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/db/DBProvider.dart';
import 'package:todoist/pages/main/main_page.dart';



class LoginPage extends StatefulWidget {
  static String tag = 'loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  String loginValue;
  String passValue;

  @override
  void initState() {
    super.initState();
    userIsSigned();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            SizedBox(height: 48,),
            SizedBox(height: 48),
            login(),
            SizedBox(
              height: 24,
            ),
            password(),
            SizedBox(
              height: 24,
            ),
            loginButton(context),
          ],
        ),
      ),
    );
  }

  login() {
    return TextFormField(
      onChanged: (text){loginValue = text;},
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  password() {
    return TextFormField(
      onChanged: (text){passValue = text;},
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )),
    );
  }

  loginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: MaterialButton(
        elevation: 5,
        //minWidth: 50,

        height: 42,
        onPressed: (){entry(loginValue, passValue, context);},
        color: Colors.blue,
        child: Text(
          'Log in',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: MediaQuery.of(context).size.height/7,
          height: 1,
          color: Colors.black26.withOpacity(0.2),
        ),
      );

  divider() => Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            horizontalLine(),
            Text(
              'или',
              style: TextStyle(color: Colors.black54),
            ),
            horizontalLine()
          ],
        ),
      );

  rememberUser(int userID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("ID", userID);
  }

  entry(String login, String pass, BuildContext context) async {
    var res =await DBProvider.db.authentication(login, pass);
    if(res != Null){
        rememberUser(res.id);
        Navigator.of(context).pushNamedAndRemoveUntil(
            MainPage.tag, (Route<dynamic> route) => false);
    }
  }

  userIsSigned() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt('ID');

    if(userID != null){
        Navigator.of(context).pushNamedAndRemoveUntil(
            MainPage.tag, (Route<dynamic> route) => false);
    }
  }

}
