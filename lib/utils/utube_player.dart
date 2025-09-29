import 'package:alandi/config/exported_path.dart';

class YoutubeUrlWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubeUrlWidget({super.key, required this.videoUrl});

  @override
  State<YoutubeUrlWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YoutubeUrlWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      aspectRatio: 9 / 16,
      progressIndicatorColor: Colors.blueAccent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
