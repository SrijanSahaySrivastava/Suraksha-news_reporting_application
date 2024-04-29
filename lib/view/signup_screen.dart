import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_send_data/view/login_screen.dart';
import 'package:test_send_data/view/new_screen.dart';
import 'package:test_send_data/widget/buttonWidget.dart';
import 'package:test_send_data/constants.dart';
// import 'camera_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  const SignUpScreen({super.key});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _mobileNumber = '';

  Future<void> _performSignUp() async {
    final response = await http.post(
      Uri.parse(
          'http://ec2-13-201-123-112.ap-south-1.compute.amazonaws.com:3000/signUp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _email,
        'firstname': _firstName,
        'lastname': _lastName,
        'MobileNo': _mobileNumber,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      print('SignUp successful');
      Fluttertoast.showToast(
        msg: "Successfully Signed Up. Redirecting to News Screen.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsScreen(user: _email),
        ),
      );
    } else {
      print('SignUp failed with status code: ${response.statusCode}');
      Fluttertoast.showToast(
        msg: "SignUp failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _onRememberMeChanged(bool? newValue) {
    setState(() {
      _rememberMe = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 45,
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _firstName = value;
                      },
                      decoration: ktextFieldDecoration.copyWith(
                        hintText: 'First Name',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ), // Spacing between first and last name fields
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _lastName = value;
                      },
                      decoration: ktextFieldDecoration.copyWith(
                        hintText: 'Last Name',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                onChanged: (value) {
                  _email = value;
                },
                decoration: ktextFieldDecoration.copyWith(
                  hintText: 'Enter Your Email',
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                onChanged: (value) {
                  _mobileNumber = value;
                },
                decoration: ktextFieldDecoration.copyWith(
                  hintText: 'Enter Your Mobile Number',
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                onChanged: (value) {
                  _password = value;
                },
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
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                label: 'SIGN UP',
                colour: Colors.black,
                onPressed: () {
                  _performSignUp();
                },
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
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Already have an Account ? ',
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
                  color:
                      Colors.grey.withOpacity(0.3), // Set the color of the line
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
