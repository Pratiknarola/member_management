import 'package:member_management/models/member.dart';
import 'package:member_management/screens/member_list.dart';
import 'package:flutter/material.dart';

class MemberDetail extends StatefulWidget {
  final String appBarTitle;
  final Member member;

  MemberDetail(this.appBarTitle, this.member);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MemberDetailState(appBarTitle, member);
  }
}

class MemberDetailState extends State<MemberDetail> {
  String appBarTitle;
  Member member;
  TextEditingController nameController = TextEditingController();
  TextEditingController regController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fieldController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController notesController = TextEditingController();


  MemberDetailState(this.appBarTitle, this.member);

  @override
  Widget build(BuildContext context) {
    bool _enabled = true;
    ThemeData theme = Theme.of(context);
    TextStyle textStyle = Theme.of(context).textTheme.title;
    // TODO: implement build
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  moveToLastScreen();
                },
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    // ignore: missing_return
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Name can not be empty";
                      }
                      if (value.length > 100) {
                        return "Name too long";
                      }
                    },
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      updateName();
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: textStyle,
                      hintText: "Name of member",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    // ignore: missing_return
                    validator: (value) {
                      if (value == null || int.parse(value) == 0) {
                        return "Reg number can not be empty";
                      }
                      if (int.parse(value) > 20219999) {
                        return "Invalid reg number";
                      }
                    },
                    controller: regController,
                    style: textStyle,
                    onChanged: (value) {
                      updateReg();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Reg no.",
                      labelStyle: textStyle,
                      hintText: "Reg no. of member",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    // ignore: missing_return
                    validator: (value) {
                      if (value == null || int.parse(value) == 0) {
                        return "Mobile number can not be empty";
                      }
                      if (value.length > 10) {
                        return "Invalid mobile number";
                      }
                    },
                    controller: mobileController,
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      updateMobile();
                    },
                    decoration: InputDecoration(
                      labelText: "Mobile no.",
                      labelStyle: textStyle,
                      hintText: "Mobile no. of member",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    // ignore: missing_return
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    style: textStyle,
                    onChanged: (value) {
                      updateMobile();
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: textStyle,
                      hintText: "Mail ID of member",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
              ]
              ),
            )
        )
    );
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  void updateName() {
    member.name = nameController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateReg() {
    member.registration_number = int.parse(regController.text);
  }

  void updateMobile() {
    member.mobilenumber = int.parse(mobileController.text);
  }
}
