import 'package:flutter/material.dart';
import 'package:test_send_data/view/signup_screen.dart';
import 'view/login_screen.dart';
import 'view/camera_screen.dart';
import 'view/new_screen.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(test_send_data(
    cameras: [cameras[0]],
  ));
}

class test_send_data extends StatelessWidget {
  const test_send_data({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.id,
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        CameraScreen.id: (context) => CameraScreen(cameras: cameras, user: ""),
        SignUpScreen.id: (context) => const SignUpScreen(),
        NewsScreen.id: (context) => const NewsScreen(user: ""),
      },
    );
  }
}
// F5 in vscode to run