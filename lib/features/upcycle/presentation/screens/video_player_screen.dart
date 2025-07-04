import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/youtube_service.dart';

class VideoPlayerScreen extends StatefulWidget {
  final YouTubeTutorial tutorial;

  const VideoPlayerScreen({
    super.key,
    required this.tutorial,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    
    if (kDebugMode) {
      print('=== Video Player Debug ===');
      print('Loading video: ${widget.tutorial.title}');
      print('Video ID: ${widget.tutorial.videoId}');
      print('Platform: ${kIsWeb ? "Web" : "Mobile"}');
    }

    _controller = YoutubePlayerController(
      initialVideoId: widget.tutorial.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        forceHD: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.headerColor,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: Text(
          widget.tutorial.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Video Player Section
          Container(
            color: Colors.black,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppTheme.primaryGreen,
              onReady: () {
                setState(() {
                  _isPlayerReady = true;
                });
                if (kDebugMode) {
                  print('✅ YouTube player ready');
                }
              },
              onEnded: (data) {
                if (kDebugMode) {
                  print('Video ended: ${data.videoId}');
                }
              },
            ),
          ),

          // Video Information Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Title
                  Text(
                    widget.tutorial.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Channel Name
                  Text(
                    widget.tutorial.channelName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await YouTubeService.openTutorial(widget.tutorial.url);
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open in YouTube'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Share functionality can be added here
                            if (kDebugMode) {
                              print('Share video: ${widget.tutorial.url}');
                            }
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryGreen,
                            side: const BorderSide(color: AppTheme.primaryGreen),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightGreen.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About this tutorial',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Learn how to create amazing upcycled projects with step-by-step instructions. This tutorial will guide you through the entire process of transforming waste materials into useful items.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Player Status (for debugging)
                  if (kDebugMode) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Debug Info:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Player Ready: $_isPlayerReady'),
                          Text('Video ID: ${widget.tutorial.videoId}'),
                          Text('Platform: ${kIsWeb ? "Web" : "Mobile"}'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
