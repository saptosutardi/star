import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final List<Map<String, String>> videos = [
    {
      'path': 'assets/exercise_video_01.mp4',
      'title': 'exerciseSquat'.tr(),
      'subtitle': 'exerciseSquatSubtitle'.tr(),
      'image': 'assets/video_1.png',
    },
    {
      'path': 'assets/exercise_video_02.mp4',
      'title': 'exerciseHeelLift'.tr(),
      'subtitle': 'exerciseHeelLiftSubtitle'.tr(),
      'image': 'assets/video_2.png',
    },
    {
      'path': 'assets/exercise_video_03.mp4',
      'title': 'exerciseThighRaise'.tr(),
      'subtitle': 'exerciseThighRaiseSubtitle'.tr(),
      'image': 'assets/video_3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('exerciseTitle'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: videos.map((video) => VideoCard(video: video)).toList(),
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final Map<String, String> video;

  const VideoCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoPath: video['path']!,
                title: video['title']!,
                subtitle: video['subtitle']!,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: 120, // Set a fixed width for the image container
              height: 120, // Set a fixed height for the image container
              child: Image.asset(
                video['image']!,
                fit: BoxFit.contain, // Use BoxFit.contain to avoid clipping
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title']!,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['subtitle']!,
                      style: const TextStyle(
                          fontSize: 18), // Adjust font size for subtitle
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final String title;
  final String subtitle;

  const VideoPlayerScreen({
    Key? key,
    required this.videoPath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            looping: true,
            fullScreenByDefault: false,
            aspectRatio: 9 / 16,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0, left: 16.0), // Adjust left padding
            child: Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left, // Set text alignment to left
            ),
          ),
        ),
      ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
