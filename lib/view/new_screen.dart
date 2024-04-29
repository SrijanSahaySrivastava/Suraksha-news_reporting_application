import 'package:flutter/material.dart';
import 'package:test_send_data/widget/buttonWidget.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(192, 207, 205, 205),
              ),
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                      Text(
                        'Hey,!',
                        style: TextStyle(
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
                        builder: (context) => NewsScreen(),
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
