import 'package:flutter/cupertino.dart';
import 'package:member_management/models/member.dart';
import 'package:member_management/screens/member_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:member_management/utils/database_helper.dart';

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
  List<String> allFields = [
    "Poster",
    "Android",
    "Photo editing",
    "PR team",
    "Oration",
    "Instagram",
    "Content",
    "Web dev",
    "Video"
  ];

  /*[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];*/

  bool _visibleCheckBox = false;
  String appBarTitle;
  Member member;

  MemberDetailState(this.appBarTitle, this.member);

  List<String> _positions = ["FrontLine", "Member", "Volunteer", "Other"];
  TextEditingController nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  TextEditingController regController = TextEditingController();
  final FocusNode _regFocus = FocusNode();

  TextEditingController mobileController = TextEditingController();
  final FocusNode _mobileFocus = FocusNode();

  TextEditingController emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  TextEditingController fieldController = TextEditingController();

  //final FocusNode _fieldFocus = FocusNode();

  TextEditingController positionController = TextEditingController();
  final FocusNode _positionFocus = FocusNode();

  TextEditingController notesController = TextEditingController();
  final FocusNode _notesFocus = FocusNode();

  TextEditingController attendenceController = TextEditingController();
  final FocusNode _attendenceFocus = FocusNode();
  DatabaseHelper helper = DatabaseHelper();

  List<bool> checkValues;
  String _dropValue;

  void setCheckvalues(List<bool> values){
    this.checkValues = values;
  }

  @override
  Widget build(BuildContext context) {
    //this.checkValues = getFieldBool(member);
    debugPrint("Started execution of build");
    ThemeData theme = Theme.of(context);
    TextStyle textStyle = Theme.of(context).textTheme.title;

    nameController.text = member.name;
    if (member.registration_number == 0) {
      regController.text = "";
    } else {
      regController.text = member.registration_number.toString();
    }
    if (member.mobilenumber == 0) {
      mobileController.text = "";
    } else {
      mobileController.text = member.mobilenumber.toString();
    }
    emailController.text = member.email;
    for(int i = 0; i < member.fields.length; i++){
      debugPrint("field value ${member.fields[i]}");
    }
    setCheckvalues(getFieldBool(member.fields));
    for(int i = 0; i < checkValues.length; i++){
      debugPrint("checkbox value i $i is ${checkValues[i]}");
    }
    notesController.text = member.note;
    _dropValue = member.position;
    debugPrint('value of dropvalue is $_dropValue');
    attendenceController.text = member.attendance.toString();

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
                      textInputAction: TextInputAction.next,
                      focusNode: _nameFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _nameFocus, _regFocus);
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
                      textInputAction: TextInputAction.next,
                      focusNode: _regFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _regFocus, _attendenceFocus);
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
                          return "attendance can not be empty";
                        }
                        if (int.parse(value) > 100) {
                          return "Invalid attendance";
                        }
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: _attendenceFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context, _attendenceFocus, _mobileFocus);
                      },
                      controller: attendenceController,
                      style: textStyle,
                      onChanged: (value) {
                        updateAttendance();
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Attendance",
                        labelStyle: textStyle,
                        hintText: "no. of attendance of member",
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
                      textInputAction: TextInputAction.next,
                      focusNode: _mobileFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _mobileFocus, _emailFocus);
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

                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _emailFocus, _positionFocus);
                      },
                      controller: emailController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint("I have got $value as email");
                        updateEmail();
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
                  CupertinoButton(
                    child: Text("Show/Hide Fields"),
                    color: Colors.lightBlue,
                    onPressed: () {
                      setState(() {
                        _visibleCheckBox = !_visibleCheckBox;
                      });
                    },
                  ),
                  Visibility(
                      visible: _visibleCheckBox,
                      child: Column(children: <Widget>[
                        CheckboxListTile(
                          title: Text(allFields[0]),
                          value: this.checkValues[0],
                          onChanged: (bool value) {
                            debugPrint("value is $value");
                            if(value) {
                              member.fields.add(allFields[0]);
                            }else{
                              member.fields.remove(allFields[0]);
                            }
                            setState(() {
                              this.checkValues[0] = !this.checkValues[0];
                            //  member.fields = boolToFields(checkValues);
                            //  updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[1]),
                          value: this.checkValues[1],
                          onChanged: (bool value) {
                            debugPrint("value is $value");
                            if(value) {
                              member.fields.add(allFields[1]);
                            }else{
                              member.fields.remove(allFields[1]);
                            }
                            setState(() {
                              this.checkValues[1] = !this.checkValues[1];
                             // member.fields = boolToFields(checkValues);
                             // updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[2]),
                          value: this.checkValues[2],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[2]);
                            }else{
                              member.fields.remove(allFields[2]);
                            }
                            setState(() {
                              this.checkValues[2] = !this.checkValues[2];
                             // member.fields = boolToFields(checkValues);
                            //  updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[3]),
                          value: checkValues[3],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[3]);
                            }else{
                              member.fields.remove(allFields[3]);
                            }
                            setState(() {
                              this.checkValues[3] = !this.checkValues[3];
                              //member.fields = boolToFields(checkValues);
                           //   updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[4]),
                          value: checkValues[4],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[4]);
                            }else{
                              member.fields.remove(allFields[4]);
                            }
                            setState(() {
                              checkValues[4] = !checkValues[4];
                              //member.fields = boolToFields(checkValues);
                             // updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[5]),
                          value: this.checkValues[5],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[5]);
                            }else{
                              member.fields.remove(allFields[5]);
                            }
                            setState(() {
                              this.checkValues[5] = !this.checkValues[5];
                             // member.fields = boolToFields(checkValues);
                              //updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[6]),
                          value: checkValues[6],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[6]);
                            }else{
                              member.fields.remove(allFields[6]);
                            }
                            setState(() {
                              checkValues[6] = !checkValues[6];
                              //member.fields = boolToFields(checkValues);
                              //updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[7]),
                          value: checkValues[7],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[7]);
                            }else{
                              member.fields.remove(allFields[7]);
                            }
                            setState(() {
                              checkValues[7] = !checkValues[7];
                              //member.fields = boolToFields(checkValues);
                              //updateFields();
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(allFields[8]),
                          value: checkValues[8],
                          onChanged: (bool value) {
                            if(value) {
                              member.fields.add(allFields[8]);
                            }else{
                              member.fields.remove(allFields[8]);
                            }
                            setState(() {
                              checkValues[8] = !checkValues[8];
                              //member.fields = boolToFields(checkValues);
                              //updateFields();
                            });
                          },
                        ),
                      ])),
                  Container(
                    child: Text(
                      "Position",
                      style: textStyle,
                    ),
                    padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 15.0),
                    child: ListTile(
                      title: DropdownButton(
                        items: _positions.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: textStyle,
                        focusNode: _positionFocus,
                        value: _dropValue,
                        // TO DO change this to member's actual position
                        onChanged: (valueSelected) {
                          setState(() {
                            _dropValue = valueSelected;
                            //updatePosition(valueSelected);
                            _fieldFocusChange(context, _emailFocus, _positionFocus);
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: notesController,
                      style: textStyle,
                      onChanged: (value) {
                        updateNote();
                      },
                      decoration: InputDecoration(
                        labelText: "Special notes",
                        labelStyle: textStyle,
                        hintText: "write your note here",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      //expands: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Save",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                updateFields();
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Delete",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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

  void updateFields() {
    member.fields = boolToFields(checkValues);
  }

  void updatePosition(valueSelected) {
    member.position = valueSelected;
  }

  void updateNote() {
    member.note = notesController.text;
  }

// List<String> allFields = ["Poster","Android","Photo editing","PR team","Oration","Instagram","Content","Web dev","Video"];
  List<bool> getFieldBool( List<String> fields) {

    List<String> allFields = [
      "Poster",
      "Android",
      "Photo editing",
      "PR team",
      "Oration",
      "Instagram",
      "Content",
      "Web dev",
      "Video"
    ];
    List<bool> checkValues = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    if(fields == null) {
      return checkValues;
    }
    for (int i = 0; i < fields.length; i++) {
      for (int j = 0; j < allFields.length; j++) {
        debugPrint("in getFieldBool with i $i and j $j");
        if (fields[i].compareTo(allFields[j]) == 0) {
          debugPrint("Found for j = $j");
          checkValues[j] = true;
          break;
        }
      }
    }

    return checkValues;
  }

  List<String> boolToFields(List<bool> checks) {
    List<String> fields = [];
    List<String> allFields = [
      "Poster",
      "Android",
      "Photo editing",
      "PR team",
      "Oration",
      "Instagram",
      "Content",
      "Web dev",
      "Video"
    ];
    for (int i = 0; i < fields.length; i++) {
      for (int j = 0; i < allFields.length; j++) {
        debugPrint("in boolToFields with i $i and j $j");
        if (checks[i]) {
          fields.add(allFields[i]);
          break;
        }
      }
    }

    return fields;
  }

  void _save() async {
    moveToLastScreen();

    int result;
    if (member.id != null) {
      // update operation
      result = await helper.updateMember(member);
    } else {
      // insert operation
      result = await helper.insertMember(member);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();

    if (member.id == null) {
      _showAlertDialog('Status', 'No Note was Deleted');
      return;
    }

    int result = await helper.deleteMember(member.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void updateEmail() {
   member.email = emailController.text;
   debugPrint("Updated email as ${member.email}");
   helper.updateMember(member);
  }

  void updateAttendance() {
    member.attendance = int.parse(attendenceController.text);
  }
}
