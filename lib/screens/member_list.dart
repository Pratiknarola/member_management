import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:member_management/models/member.dart';
import 'package:member_management/screens/member_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:member_management/utils/database_helper.dart';


class MemberList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MemberListState();
  }
}

class MemberListState extends State<MemberList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Member> memberList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (memberList == null) {
      memberList = List<Member>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Green Club Members",
        ),
        backgroundColor: Colors.green,
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB clicked");
          navigateToDetail(Member("", 0, 0, "", [], "", ""), "Add Member");
        },
        tooltip: "Add note",
        child: Icon(Icons.person_add),
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int posi) {
          return Card(color: Colors.white, elevation: 2.0, child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPositionColor(this.memberList[posi].position), // TODO implement color according to position
              child: Icon(Icons.play_arrow),
            ),
            onTap: (){
              debugPrint("tile clicked");
              navigateToDetail(this.memberList[posi], "Edit Member");
            },
            onLongPress: (){
              debugPrint("long pressed");
            },
            title: Text(
              this.memberList[posi].name,
              style: titleStyle,
            ),
            subtitle: Text(this.memberList[posi].attendence.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.add, color: Colors.grey,),
              onTap: (){
                debugPrint("Increase attendance");
                this.memberList[posi].attendence++;
                databaseHelper.updateMember(this.memberList[posi]);
                updateListView();
                _showSnackBar(context, "Attendance updated", this.memberList[posi]);
                },
            ),
          ));
        });
  }

  void navigateToDetail(Member member, String appBarTitle) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MemberDetail(appBarTitle, member);
    }));

    if(result){
      updateListView();
    }
  }
//["FrontLine", "Member", "Volunteer", "Other"]
  Color getPositionColor(position){
    switch (position){
      case "FrontLine": return Colors.red; break;
      case "Member": return Colors.yellow; break;
      case "Volunteer": return Colors.green; break;
      case "Other": return Colors.deepPurple; break;

    }
  }

  void _showSnackBar(BuildContext context, String message, Member member){
    final snackbar = SnackBar(content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: (){
          member.attendence--;
          databaseHelper.updateMember(member);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Undo Done"),));
          updateListView();
        },
      ),);
    Scaffold.of(context).showSnackBar(snackbar);
  }




  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Member>> memberListFuture = databaseHelper.getMemberList();
      memberListFuture.then((memberList){
        setState(() {
          this.memberList = memberList;
          this.count = memberList.length;
        });
      });
    });
  }
}
