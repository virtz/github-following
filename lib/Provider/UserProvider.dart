import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_following/Models/Users.dart';
import 'package:github_following/Requests/GitHubRequest.dart';

class UserProvider with ChangeNotifier {
  User user;
  String errorMessage;
  bool loading = false;

  Future<bool> fetchUser(username) async {
    setLoading(true);

   await  GitHub(username).fetchUser().then((data) {
     setLoading(false);
      if (data.statusCode == 200) {
        setUser(User.fromJson(json.decode(data.body)));
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setMessage(result['message']);
      }
    });
   return isUser();
  }

bool isLoading(){
  return loading; 
}
  void setLoading(value) {
    loading = value;
    notifyListeners();
  }
User getUser(){
  return user;
}
  void setUser(value) {
    user = value;
    notifyListeners();
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage(){
    return errorMessage;
  }

  bool isUser(){
    return user !=null ?true:false;
  }
}
