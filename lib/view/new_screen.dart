import 'package:flutter/material.dart';
import 'package:test_send_data/widget/buttonWidget.dart';
import 'package:test_send_data/widget/imageCard.dart';
import 'camera_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

class NewsScreen extends StatefulWidget {
  static const String id = 'news_screen';

  final String user;
  const NewsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class Post {
  String imageUrl;
  final String description;
  final String longitude;
  final String latitude;
  final int sentiment;

  Post({
    required this.imageUrl,
    required this.description,
    required this.longitude,
    required this.latitude,
    required this.sentiment,
  });
}

class _NewsScreenState extends State<NewsScreen> {
  List<Post> posts = [];
  late String city;

  Future<void> blurFace(Post post) async {
    final response = await http.post(
      Uri.parse(
        'http://ec2-13-232-63-159.ap-south-1.compute.amazonaws.com:3000/blur_face?url=${post.imageUrl}',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);
    if (response.statusCode == 200) {
      String newImageUrl = jsonDecode(response.body)['url']['signedUrl'];
      setState(() {
        post.imageUrl = newImageUrl;
      });
    }
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-201-123-112.ap-south-1.compute.amazonaws.com:3000/posts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonPosts = jsonDecode(response.body)['posts'];
      setState(() {
        posts.clear();
        for (var jsonPost in jsonPosts) {
          Post post = Post(
            imageUrl: jsonPost['image'],
            description: jsonPost['content'],
            longitude: jsonPost['longitude'],
            latitude: jsonPost['latitude'],
            sentiment: jsonPost['sentiment'],
          );
          posts.add(post);
        }
      });
      for (var post in posts) {
        await blurFace(post);
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Screen'),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CameraScreen(cameras: cameras, user: widget.user),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buttonWidget(
                label: 'Latest News',
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
          ],
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const WaterDropHeader(
          waterDropColor: Colors.blue,
          idleIcon: Icon(Icons.refresh, color: Colors.blue),
        ),
        onRefresh: () async {
          await fetchPosts();
          _refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Column(
            children: posts
                .map((post) => InkWell(
                      onTap: () {
                        String url =
                            'https://www.google.com/maps/search/?api=1&query=${post.latitude},${post.longitude}';
                        launchUrl(Uri.parse(url));
                      },
                      child: ImageCard(
                        imageUrl: post.imageUrl,
                        description: post.description,
                        sentiment: post.sentiment,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
