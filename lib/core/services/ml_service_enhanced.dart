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
      // Web platform: TensorFlow Lite limitations explained
      if (kDebugMode) {
        print('=== TensorFlow Lite Web Limitations ===');
        print('❌ TensorFlow Lite does NOT work in web browsers because:');
        print('1. TensorFlow Lite is designed for mobile/embedded devices');
        print('2. Web browsers cannot access native TensorFlow Lite libraries');
        print('3. JavaScript/WebAssembly has different runtime requirements');
        print('4. Alternative: Use TensorFlow.js for web-based ML inference');
        print('5. Current solution: Mock data for web compatibility');
        print('Using mock ML results for web platform');
      }
      return _getMockResult();
    } else {
      // Mobile platform: Ready for real model
      if (kDebugMode) {
        print('=== Mobile Platform ML Status ===');
        print('✅ TensorFlow Lite IS supported on mobile platforms');
        print('📱 Android/iOS can run .tflite models natively');
        print('🔧 Currently using mock data (TensorFlow Lite package disabled in pubspec.yaml)');
        print('📁 Your model.tflite is ready in assets/ml_models/');
        print('🚀 To enable: Uncomment tflite_flutter in pubspec.yaml');
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

    // DEBUG LOGGING: ML Service behavior
    if (kDebugMode) {
      print('=== ML Service Debug ===');
      print('Using mock result (TensorFlow Lite disabled)');
      print('Available labels: $availableLabels');
      print('Selected label: $randomLabel');
      print('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      print('TensorFlow Lite support: ${kIsWeb ? "Not supported" : "Available but disabled"}');
    }

    // Clean the label to remove count prefixes (addressing "0 bottle", "2 tincan" issue)
    String cleanLabel = randomLabel;
    if (cleanLabel.contains(' ')) {
      final parts = cleanLabel.split(' ');
      if (parts.length > 1 && RegExp(r'^\d+$').hasMatch(parts[0])) {
        cleanLabel = parts.sublist(1).join(' ');
        if (kDebugMode) {
          print('Cleaned label from "$randomLabel" to "$cleanLabel"');
        }
      }
    }

    return WasteDetectionResult(
      label: cleanLabel,
      confidence: 0.85 + (DateTime.now().millisecond % 15) / 100, // Random confidence 0.85-0.99
      suggestions: _getUpcyclingSuggestions(cleanLabel),
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
