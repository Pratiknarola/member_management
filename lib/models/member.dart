class Member {

  int _id;
  int _registration_number;
  int _attendance = 0;
  String _name;
  String _email;
  int _mobilenumber;
  String _note;
  String _position;
  List<String> _fields = [];

  Member(this._name, this._registration_number, this._mobilenumber, this._email, this._fields, this._position, [this._note]);
  Member.withId(this._id, this._name, this._registration_number, this._mobilenumber, this._email, this._fields, this._position, [this._note]);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get registration_number => _registration_number;

  List<String> get fields => _fields;

  set fields(List<String> value) {
    _fields = value;
  }

  String get position => _position;

  set position(String value) {
    _position = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  int get mobilenumber => _mobilenumber;

  set mobilenumber(int value) {
    _mobilenumber = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get attendance => _attendance;

  set attendance(int value) {
    _attendance = value;
  }

  set registration_number(int value) {
    _registration_number = value;
  }

  String convertToYN(List<String> fields){
    if(fields == null){
      return "NNNNNNNNN";
    }
    List<String> allFields = ["Poster","Android","Photo editing","PR team","Oration","Instagram","Content","Web dev","Video"];
    String result = "NNNNNNNNN";
    for(int i = 0; i < fields.length; i++){
      for(int j = 0; j < allFields.length; j++){
        if(fields[i].compareTo(allFields[j]) == 0){
          result = result.replaceFirst(RegExp("N"), "Y", j);
          break;
        }
      }
    }
    return result;
  }

  List<String> fromYN(String ynList){
    List<String> allFields = ["Poster","Android","Photo editing","PR team","Oration","Instagram","Content","Web dev","Video"];
    List<String> fields;
    for(int i = 0; i < ynList.length; i++){
      if(ynList[i] == 'Y'){
        fields.add(allFields[i]);
      }
    }
    return fields;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(id != null){
      map['id'] = _id;
    }
    map['name'] = _name;
    map['registration_number'] = _registration_number;
    map['mobilenumber'] = _mobilenumber;
    map['fields'] = convertToYN(_fields);
    map['position'] = _position;
    map['note'] = _note;
    map['email'] = _email;
    map['attendance'] = _attendance;


    return map;
  }

  Member.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this.name = map['name'];
    this._registration_number = map['registration_number'];
    this._mobilenumber = map['mobilenumber'];
    this._fields = fromYN(map['fields']);
    this._position = map['position'];
    this._note = map['note'];
    this._email = map['email'];
    this._attendance = map['attendance'];

  }



}