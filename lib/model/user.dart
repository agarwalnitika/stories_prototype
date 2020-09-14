import 'package:meta/meta.dart';

class User{
  User({@required this.id,@required this.email });
  final id;
  final String email;



  factory User.fromMap(Map<String, dynamic> data , String documentID) {
    if(data == null){
      return null;
    }
    final String name = data['name'];

    return User(
      id: documentID,
      email: name,
    );
  }

  Map<String, dynamic> toMap() {
    print('abc');
    return {
      'email': email,
    };
  }
}

