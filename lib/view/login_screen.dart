import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_send_data/view/signup_screen.dart';
import 'package:test_send_data/widget/buttonWidget.dart';
import 'package:test_send_data/constants.dart';
// import 'camera_screen.dart';
import 'new_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    if (email != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewsScreen(user: email),
        ),
      );
    }
  }

  void _onRememberMeChanged(bool? newValue) {
    setState(() {
      _rememberMe = newValue ?? false;
    });
  }

  Future<void> _performLogin() async {
    final response = await http.post(
      Uri.parse(
          'http://ec2-13-201-123-112.ap-south-1.compute.amazonaws.com:3000/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _email,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      print('Login successful');
      Fluttertoast.showToast(
        msg: "Successfully logged in. Redirecting to News Screen.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (_rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _email);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsScreen(user: _email),
        ),
      );
    } else {
      print('Login failed with status code: ${response.statusCode}');
      // Add a toast for error
      Fluttertoast.showToast(
        msg: "Login failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(70.0),
          child: Text(
            'Suraksha', // TODO: Add Title
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 50.0,
              ),
              Container(
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 45,
                  ),
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: ktextFieldDecoration.copyWith(
                      hintText: 'Enter Your Email')),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _rememberMe,
                    onChanged: _onRememberMeChanged,
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                  ),
                  const Text('Remember Me'),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              buttonWidget(
                label: 'LOG IN',
                colour: Colors.black,
                onPressed: _performLogin,
                textstyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.zero,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 2.0,
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
