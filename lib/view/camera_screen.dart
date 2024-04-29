import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:test_send_data/widget/buttonWidget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'new_screen.dart';

late List<CameraDescription> cameras;

class WebSocketService {
  late WebSocketChannel _channel;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://ec2-13-201-123-112.ap-south-1.compute.amazonaws.com:4000/'),
    );

    _channel.stream.listen((message) {
      print('Received message from server: $message');
    });
  }

  void close() {
    _channel.sink.close();
  }

  void sendImageData(
      String imageUrl, String latitude, String longitude, String user) {
    final jsonData = jsonEncode({
      'email': user,
      'image': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    });
    _channel.sink.add(jsonData);
  }
}

class CameraScreen extends StatefulWidget {
  static const String id = 'camera_screen';
  String user = "shashwat123student@gmail.com";
  CameraScreen({required this.cameras, Key? key, required this.user})
      : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  File? _imageFile;
  Future<void>? _uploadFuture;
  late WebSocketService _webSocketService;

  Future<void> _takePicture(String user) async {
    if (!_cameraController.value.isTakingPicture) {
      final image = await _cameraController.takePicture();

      final directory = await getApplicationDocumentsDirectory();
      final File imageFile = File(
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png');
      await imageFile.writeAsBytes(await image.readAsBytes());
      setState(() {
        _imageFile = imageFile;
      });
      await uploadImage(imageFile, user);
      Fluttertoast.showToast(
        msg: "Image uploaded successfully!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print('Camera is currently processing an image.');
    }
  }

  Future<void> uploadImage(File imageFile, String user) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://ec2-43-204-100-197.ap-south-1.compute.amazonaws.com:3000/upload'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('photo', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: ${response.body}');
      }

      var responseData = response.body;
      print('Signed URL: $responseData');
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _webSocketService.sendImageData(
        responseData,
        position.latitude.toString(),
        position.longitude.toString(),
        user,
      );
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
    _webSocketService = WebSocketService();
    _webSocketService.connect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Camera Screen for user: ${widget.user}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(192, 207, 205, 205),
              ),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                      Text(
                        'Hey, ${widget.user}!',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buttonWidget(
                label: 'Report News',
                colour: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buttonWidget(
                label: 'Latest News',
                colour: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsScreen(user: widget.user),
                      ));
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
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CameraPreview(_cameraController);
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () {
          setState(() {
            _uploadFuture = _takePicture(widget.user);
          });
        },
      ),
    );
  }
}
