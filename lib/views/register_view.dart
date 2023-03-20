import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('Health App Registration'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            aboutSection,
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final UserCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    devtools.log(UserCredential.toString());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      devtools.log("weak password");
                    } else {
                      devtools.log(e.code);
                    }
                  }
                  // const snackBar =
                  //     SnackBar(content: const Text('Sign up form coming soon'));
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent[100],
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (route) => false);
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                foregroundColor: Color.fromARGB(238, 46, 59, 65),
              ),
              child: const Text('Not a new User? Login here'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Forgot Password'),
        icon: const Icon(
          Icons.assistant,
          color: Colors.amber,
          size: 30.0,
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget aboutSection = Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'About Us',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            'Our mission is to provide high-quality healthcare services to our customers.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              letterSpacing: 2.0,
              color: Colors.blueGrey.shade900,
            ),
          ),
          SizedBox(height: 2.0),
        ],
      ));
}
