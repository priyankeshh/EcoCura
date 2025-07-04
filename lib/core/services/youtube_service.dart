import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeService {
  static Future<List<YouTubeTutorial>> searchTutorials(String wasteType, String projectName) async {
    // For now, using mock tutorials with real search URLs
    // In production, you can integrate with YouTube Data API v3
    return _getMockTutorials(wasteType, projectName);
  }

  static List<YouTubeTutorial> _getMockTutorials(String wasteType, String projectName) {
    final query = 'DIY $projectName from $wasteType tutorial';
    final searchUrl = 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}';

    // FIXED: Real YouTube video IDs for embedded playback
    final mockTutorials = {
      'plastic bottles': {
        'Bird Feeder': [
          YouTubeTutorial(
            title: 'Easy Plastic Bottle Bird Feeder DIY',
            channelName: 'DIY Crafts',
            videoId: 'PfLkJbEU6q4', // Real YouTube video ID for bird feeder tutorial
            thumbnailUrl: 'https://img.youtube.com/vi/PfLkJbEU6q4/maxresdefault.jpg',
            url: 'https://www.youtube.com/watch?v=PfLkJbEU6q4',
          ),
          YouTubeTutorial(
            title: 'Beautiful Bird Feeder from Waste Bottles',
            channelName: 'Eco Crafts',
            videoId: 'qOH9k8-Ndjk', // Real YouTube video ID for bottle bird feeder
            thumbnailUrl: 'https://img.youtube.com/vi/qOH9k8-Ndjk/maxresdefault.jpg',
            url: 'https://www.youtube.com/watch?v=qOH9k8-Ndjk',
          ),
          YouTubeTutorial(
            title: 'Kids DIY: Bottle Bird Feeder Project',
            channelName: 'Family Crafts',
            videoId: 'Yz8YfnLTPeE', // Real YouTube video ID for kids DIY
            thumbnailUrl: 'https://img.youtube.com/vi/Yz8YfnLTPeE/maxresdefault.jpg',
            url: 'https://www.youtube.com/watch?v=Yz8YfnLTPeE',
          ),
        ],
        'Planter Pot': [
          YouTubeTutorial(
            title: 'Self-Watering Planter from Plastic Bottle',
            channelName: 'Garden DIY',
            videoId: 'CPu1vHaJiVg', // Real YouTube video ID for self-watering planter
            thumbnailUrl: 'https://img.youtube.com/vi/CPu1vHaJiVg/maxresdefault.jpg',
            url: 'https://www.youtube.com/watch?v=CPu1vHaJiVg',
          ),
          YouTubeTutorial(
            title: 'Hanging Garden: Bottle Planters',
            channelName: 'Urban Gardening',
            videoId: 'YhvfOlPYifY', // Real YouTube video ID for hanging planters
            thumbnailUrl: 'https://img.youtube.com/vi/YhvfOlPYifY/maxresdefault.jpg',
            url: 'https://www.youtube.com/watch?v=YhvfOlPYifY',
          ),
          YouTubeTutorial(
            title: 'Decorative Bottle Planters Tutorial',
            channelName: 'Home Decor DIY',
            videoId: 'mock6',
            thumbnailUrl: 'https://via.placeholder.com/320x180/CDDC39/FFFFFF?text=Decorative',
            url: searchUrl,
          ),
        ],
        'Pen Holder': [
          YouTubeTutorial(
            title: 'Cute Desk Organizer from Bottles',
            channelName: 'Office DIY',
            videoId: 'kAqIJZeeXEc', // Real YouTube video ID for pen holder
            thumbnailUrl: 'https://img.youtube.com/vi/kAqIJZeeXEc/maxresdefault.jpg',
            url: 'https://www.youtube.com/watch?v=kAqIJZeeXEc',
          ),
          YouTubeTutorial(
            title: 'Pencil Holder: Bottle Upcycling',
            channelName: 'School Crafts',
            videoId: 'mock8',
            thumbnailUrl: 'https://via.placeholder.com/320x180/E91E63/FFFFFF?text=Pencil+Holder',
            url: searchUrl,
          ),
          YouTubeTutorial(
            title: 'Multi-compartment Organizer DIY',
            channelName: 'Organization Hacks',
            videoId: 'mock9',
            thumbnailUrl: 'https://via.placeholder.com/320x180/3F51B5/FFFFFF?text=Multi+Organizer',
            url: searchUrl,
          ),
        ],
      },
      'wood': {
        'Bookshelf': [
          YouTubeTutorial(
            title: 'Simple Wood Bookshelf Build',
            channelName: 'Woodworking Basics',
            videoId: 'mock10',
            thumbnailUrl: 'https://via.placeholder.com/320x180/795548/FFFFFF?text=Bookshelf',
            url: searchUrl,
          ),
        ],
        'Picture Frame': [
          YouTubeTutorial(
            title: 'Rustic Wood Picture Frame DIY',
            channelName: 'Frame Crafts',
            videoId: 'mock11',
            thumbnailUrl: 'https://via.placeholder.com/320x180/8D6E63/FFFFFF?text=Picture+Frame',
            url: searchUrl,
          ),
        ],
        'Garden Planter Box': [
          YouTubeTutorial(
            title: 'Raised Garden Bed from Reclaimed Wood',
            channelName: 'Garden Projects',
            videoId: 'mock12',
            thumbnailUrl: 'https://via.placeholder.com/320x180/689F38/FFFFFF?text=Garden+Box',
            url: searchUrl,
          ),
        ],
      },
      'cardboard': {
        'Storage Organizer': [
          YouTubeTutorial(
            title: 'Cardboard Storage Box Tutorial',
            channelName: 'Organization DIY',
            videoId: 'mock13',
            thumbnailUrl: 'https://via.placeholder.com/320x180/FF5722/FFFFFF?text=Storage+Box',
            url: searchUrl,
          ),
        ],
        'Cat House': [
          YouTubeTutorial(
            title: 'Amazing Cardboard Cat Castle',
            channelName: 'Pet DIY',
            videoId: 'mock14',
            thumbnailUrl: 'https://via.placeholder.com/320x180/FF9800/FFFFFF?text=Cat+Castle',
            url: searchUrl,
          ),
        ],
        'Desk Organizer': [
          YouTubeTutorial(
            title: 'Cardboard Desk Organizer with Compartments',
            channelName: 'Office Organization',
            videoId: 'mock15',
            thumbnailUrl: 'https://via.placeholder.com/320x180/607D8B/FFFFFF?text=Desk+Organizer',
            url: searchUrl,
          ),
        ],
      },
      'tin cans': {
        'Lantern': [
          YouTubeTutorial(
            title: 'Tin Can Lantern with Beautiful Patterns',
            channelName: 'Light Crafts',
            videoId: 'mock16',
            thumbnailUrl: 'https://via.placeholder.com/320x180/FFC107/FFFFFF?text=Tin+Lantern',
            url: searchUrl,
          ),
        ],
        'Pencil Holder': [
          YouTubeTutorial(
            title: 'Decorated Tin Can Pencil Holder',
            channelName: 'Craft Ideas',
            videoId: 'mock17',
            thumbnailUrl: 'https://via.placeholder.com/320x180/9E9E9E/FFFFFF?text=Pencil+Holder',
            url: searchUrl,
          ),
        ],
        'Succulent Planter': [
          YouTubeTutorial(
            title: 'Mini Succulent Garden in Tin Cans',
            channelName: 'Succulent Care',
            videoId: 'mock18',
            thumbnailUrl: 'https://via.placeholder.com/320x180/4CAF50/FFFFFF?text=Succulent+Garden',
            url: searchUrl,
          ),
        ],
      },
    };

    final wasteKey = wasteType.toLowerCase();
    final projectKey = projectName.split(' - ')[0]; // Get project name before description
    
    return mockTutorials[wasteKey]?[projectKey] ?? [
      YouTubeTutorial(
        title: 'DIY $projectName Tutorial',
        channelName: 'Craft Channel',
        videoId: 'mock',
        thumbnailUrl: 'https://via.placeholder.com/320x180/4CAF50/FFFFFF?text=DIY+Tutorial',
        url: searchUrl,
      ),
    ];
  }

  static Future<void> openTutorial(String url) async {
    if (kDebugMode) {
      print('=== YouTube Service Debug ===');
      print('Attempting to open URL: $url');
      print('Platform: ${defaultTargetPlatform.name}');
      print('Is Web: $kIsWeb');
    }

    try {
      final uri = Uri.parse(url);
      if (kDebugMode) {
        print('Parsed URI: $uri');
        print('Checking if URL can be launched...');
      }

      if (await canLaunchUrl(uri)) {
        if (kDebugMode) {
          print('✅ URL can be launched, opening in external application...');
        }
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (kDebugMode) {
          print('✅ URL launched successfully');
        }
      } else {
        if (kDebugMode) {
          print('❌ URL cannot be launched');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error opening tutorial: $e');
        print('Error type: ${e.runtimeType}');
      }
    }
  }
}

class YouTubeTutorial {
  final String title;
  final String channelName;
  final String videoId;
  final String thumbnailUrl;
  final String url;

  YouTubeTutorial({
    required this.title,
    required this.channelName,
    required this.videoId,
    required this.thumbnailUrl,
    required this.url,
  });
}
