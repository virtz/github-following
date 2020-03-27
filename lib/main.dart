import 'package:flutter/material.dart';
import 'package:github_following/Pages/FollowingPage.dart';
import 'package:github_following/Provider/UserProvider.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(),
      child: MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();

  void getUser() {
    if (_controller.text == '') {
      Provider.of<UserProvider>(context, listen: false)
          .setMessage('Please enter your username');
    } else {
      Provider.of<UserProvider>(context, listen: false)
          .fetchUser(_controller.text)
          .then((value) {
        if (value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FollowingPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
              color: Colors.black,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(height: 100),
                    Container(
                        width: 80,
                        height: 80,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              'https://icon-library.net/images/github-icon-png/github-icon-png-29.jpg'),
                        )),
                    SizedBox(height: 30),
                    Text("Github",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 150.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(.0)),
                      child: TextField(
                          onChanged: (value) {
                            userProvider.setMessage(null);
                          },
                          controller: _controller,
                          enabled: !userProvider.isLoading(),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              errorText: userProvider.getMessage(),
                              border: InputBorder.none,
                              hintText: "Github username",
                              hintStyle: TextStyle(color: Colors.grey))),
                    ),
                    SizedBox(height: 20.0),
                    MaterialButton(
                      padding: EdgeInsets.all(20),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Align(
                        child: userProvider.isLoading()
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white, strokeWidth: 2)
                            : Text('Get Your Following Now',
                                style: TextStyle(color: Colors.white)),
                      ),
                      onPressed: () {
                        getUser();
                      },
                    )
                  ]))),
        ));
  }
}
