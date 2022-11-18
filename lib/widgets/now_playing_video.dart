import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NowPlayingVideo extends StatefulWidget {
  final String keyVal;
  const NowPlayingVideo({Key? key, required this.keyVal}) : super(key: key);

  @override
  State<NowPlayingVideo> createState() => _NowPlayingVideoState();
}

class _NowPlayingVideoState extends State<NowPlayingVideo> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController(initialVideoId: widget.keyVal);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ),
            Positioned(
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}