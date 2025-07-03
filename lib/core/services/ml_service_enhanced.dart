import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MLService {
  static List<String>? _labels;
  static bool _isInitialized = false;

  // Initialize the ML model (web-compatible)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load labels
      final labelsData = await rootBundle.loadString('assets/ml_models/labels.txt');
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();

      _isInitialized = true;
      if (kDebugMode) {
        if (kIsWeb) {
          print('ML Service initialized with mock data (Web platform - TensorFlow Lite not supported)');
        } else {
          print('ML Service initialized - Ready for real model on mobile platform');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize ML Service: $e');
      }
      _isInitialized = false;
    }
  }

  // Classify waste from image bytes (web-compatible with mock data)
  static Future<WasteDetectionResult> classifyWaste(Uint8List imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    // For web compatibility, always use mock results
    // On mobile platforms, you can integrate real TensorFlow Lite here
    if (kIsWeb) {
      return _getMockResult();
    }

    // For mobile platforms, you would implement real ML inference here
    // For now, using mock data for all platforms
    return _getMockResult();
  }



  // Get upcycling suggestions based on detected waste type
  static List<String> _getUpcyclingSuggestions(String wasteType) {
    final suggestions = {
      'plastic bottles': [
        'Bird Feeder - Cut holes and add perches for birds',
        'Planter Pot - Perfect container for herbs and small plants',
        'Pen Holder - Organize desk supplies and stationery',
      ],
      'wood': [
        'Bookshelf - Create simple shelving for storage',
        'Picture Frame - Make custom frames for photos',
        'Garden Planter Box - Build raised beds for plants',
      ],
      'cardboard': [
        'Storage Organizer - Multiple compartments for items',
        'Cat House - Fun shelter project for pets',
        'Desk Organizer - Sort papers and office supplies',
      ],
      'tin cans': [
        'Lantern - Add holes for beautiful light patterns',
        'Pencil Holder - Wrap with decorative paper',
        'Succulent Planter - Perfect size for small plants',
      ],
    };

    return suggestions[wasteType.toLowerCase()] ?? [
      'Creative Decoration - Paint and personalize',
      'Storage Solution - Organize small items',
      'Garden Helper - Use in outdoor projects',
    ];
  }

  // Mock result for development/fallback
  static WasteDetectionResult _getMockResult() {
    final mockLabels = ['Plastic Bottles', 'Wood', 'Cardboard', 'Tin cans'];
    final randomLabel = mockLabels[DateTime.now().millisecond % mockLabels.length];

    return WasteDetectionResult(
      label: randomLabel,
      confidence: 0.85 + (DateTime.now().millisecond % 15) / 100, // Random confidence 0.85-0.99
      suggestions: _getUpcyclingSuggestions(randomLabel),
    );
  }

  static void dispose() {
    _labels = null;
    _isInitialized = false;
  }
}

class WasteDetectionResult {
  final String label;
  final double confidence;
  final List<String> suggestions;

  WasteDetectionResult({
    required this.label,
    required this.confidence,
    required this.suggestions,
  });
}
