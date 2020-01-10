import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:member_management/models/member.dart';
import 'package:member_management/screens/member_details.dart';

class MemberList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MemberListState();
  }
}

class MemberListState extends State<MemberList> {
  List<Member> memberList;
  int count = 5;

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
          navigateToDetail(Member("prtik", 0, 0, "", [""], "", ""), "Add Member");
        },
        tooltip: "Add note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(color: Colors.white, elevation: 2.0, child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red, // TODO implement color according to position
              child: Icon(Icons.play_arrow),
            ),
            onTap: (){
              debugPrint("tile clicked");
              navigateToDetail(Member("pratik", 0, 0, "", [""], "", ""), "Edit Member");
            },
            onLongPress: (){
              debugPrint("long pressed");
            },
            title: Text("Sample name", style: titleStyle,),
            subtitle: Text("Sample subtitle"),

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
  void updateListView() {}
}
