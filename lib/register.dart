import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobsheet10/first_screen_email.dart';

class Register extends StatefulWidget {
  final String title = 'Register With Email';
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context, true),
                        );

                        AlertDialog alert = AlertDialog(
                          title: Text("Error"),
                          content: Text("Password terlalu lemah."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        signinnow();
                      }
                    } catch (e) {
                      print(e);
                    }
                    check_auth();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signinnow() async {
    print('bobo');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Widget okButton2 = FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context, true),
        );

        AlertDialog alert2 = AlertDialog(
          title: Text("Error"),
          content: Text("Passwordnya salah!"),
          actions: [
            okButton2,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert2;
          },
        );
      }
    } catch (e) {
      print(e);
    }
    check_auth();
  }

  check_auth() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return FirstScreenEmail(user);
        }));
      }
    });
  }
}
