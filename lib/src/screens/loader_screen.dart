import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class LoaderScreen extends StatefulWidget {
  final int initialFrame;

  const LoaderScreen({
    super.key,
    required this.initialFrame,
  });

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen>
    with TickerProviderStateMixin {
  late GifController controller;

  @override
  void didChangeDependencies() {
    // Adjust the provider based on the image type
    precacheImage(const AssetImage('assets/images/rating/1_Star.gif'), context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller = GifController(
      onFrame: (frame) {
        if (frame == widget.initialFrame) {
          controller.stop();
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: GifView.asset(
            'assets/images/rating/1_Star.gif',
            controller: controller,
            height: 500,
            width: 500,
            frameRate: 30,
          ),
        ),
      );
}
