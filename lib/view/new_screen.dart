import 'package:flutter/material.dart';
import 'package:test_send_data/widget/imageCard.dart';

class NewsScreen extends StatefulWidget {
  static const String id = 'news_screen';
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<String> imageUrls = [
    'https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/w_1280,c_limit/Gear-Photos-597589287.jpg',
    'https://media.wired.com/photos/66199f3fca83ba47f0a9b809/master/w_1280,c_limit/Apple-Shortcuts-Journal-Gear.jpg',
    // Add more image URLs
  ];
  final List<String> titles = [
    'Title 1',
    'Title 2',
    // Add more titles
  ];
  final List<String> descriptions = [
    'Description 1',
    'Description 2',
    // Add more descriptions
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: imageUrls
              .map((imageUrl) => ImageCard(
                    imageUrl: imageUrl,
                    title: titles[imageUrls.indexOf(imageUrl)],
                    description: descriptions[imageUrls.indexOf(imageUrl)],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
