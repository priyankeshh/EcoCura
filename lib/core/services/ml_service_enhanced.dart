import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// TensorFlow Lite will be added when the package is stable

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

    if (kIsWeb) {
      // Web platform: Use mock results (TensorFlow Lite not supported)
      if (kDebugMode) {
        print('Using mock ML results for web platform');
      }
      return _getMockResult();
    } else {
      // Mobile platform: Ready for real model
      if (kDebugMode) {
        print('Mobile platform detected - would use real model.tflite here');
        print('Currently using mock data until real TensorFlow Lite is enabled');
      }

      // Mobile platform: Using mock data for now
      // Your model.tflite is ready to be integrated when TensorFlow Lite package is stable
      if (kDebugMode) {
        print('Mobile platform detected - Your model.tflite is ready for integration');
        print('Currently using enhanced mock data with your 4 waste categories');
      }
      return _getMockResult();
    }
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
    // Use the loaded labels if available, otherwise use default
    final availableLabels = _labels ?? ['Plastic Bottles', 'Wood', 'Cardboard', 'Tin cans'];
    final randomLabel = availableLabels[DateTime.now().millisecond % availableLabels.length];

    return WasteDetectionResult(
      label: randomLabel,
      confidence: 0.85 + (DateTime.now().millisecond % 15) / 100, // Random confidence 0.85-0.99
      suggestions: _getUpcyclingSuggestions(randomLabel),
    );
  }

  // Real ML inference will be implemented when TensorFlow Lite package is stable
  // Your model.tflite is ready and waiting in assets/ml_models/model.tflite

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
