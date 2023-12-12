import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppFeed(),
    );
  }
}

class AppFeed extends StatefulWidget {
  @override
  _AppFeedState createState() => _AppFeedState();
}

class _AppFeedState extends State<AppFeed> {
  // List of image URLs
  final List<String> _imageUrls = [
    'https://i.imgur.com/NEKJ0pU.png',
    'https://i.imgur.com/J6Kagcc.png',
    'https://i.imgur.com/J6Kagcc.png',
    'https://i.imgur.com/NEKJ0pU.png',
    'https://i.imgur.com/WPYUiky.png',
    'https://i.imgur.com/c0ETpqQ.png',
    'https://i.imgur.com/J6Kagcc.png',
  ];

  bool pixelationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Feed'),
      ),
      body: _addShader(
        child: Container(
          color: Colors.white54,
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: _imageUrls.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() => pixelationEnabled = true);
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Image.network(_imageUrls[index]),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        setState(() => pixelationEnabled = false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(_imageUrls[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addShader({required Widget child}) {
    if (pixelationEnabled) {
      return ShaderBuilder(
        (context, shader, _) {
          return AnimatedSampler(
            (image, size, canvas) {
              shader.setFloat(0, size.width);
              shader.setFloat(1, size.height);
              shader.setImageSampler(0, image);

              canvas.drawRect(
                Rect.fromLTWH(0, 0, size.width, size.height),
                Paint()..shader = shader,
              );
            },
            child: child,
          );
        },
        assetKey: "shaders/pixelated_blur.frag",
      );
    }
    return child;
  }

  void onAnimate() {}
}
