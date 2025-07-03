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

      // TODO: Uncomment this when ready for real ML on mobile:
      // return await _runRealInference(imageBytes);

      // For now, return mock data even on mobile
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
    final mockLabels = ['Plastic Bottles', 'Wood', 'Cardboard', 'Tin cans'];
    final randomLabel = mockLabels[DateTime.now().millisecond % mockLabels.length];

    return WasteDetectionResult(
      label: randomLabel,
      confidence: 0.85 + (DateTime.now().millisecond % 15) / 100, // Random confidence 0.85-0.99
      suggestions: _getUpcyclingSuggestions(randomLabel),
    );
  }

  // Real ML inference method (for mobile platforms)
  // Uncomment and use this when you want to enable real TensorFlow Lite
  /*
  static Future<WasteDetectionResult> _runRealInference(Uint8List imageBytes) async {
    try {
      // Load the model if not already loaded
      final interpreter = await Interpreter.fromAsset('assets/ml_models/model.tflite');

      // Preprocess image to 224x224x3
      final input = _preprocessImageForModel(imageBytes);

      // Prepare output tensor
      final output = [List.filled(_labels!.length, 0.0)];

      // Run inference
      interpreter.run(input, output);

      // Process results
      final result = _processModelOutput(output[0]);

      // Clean up
      interpreter.close();

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Real ML inference failed: $e');
      }
      return _getMockResult();
    }
  }

  static List<List<List<List<double>>>> _preprocessImageForModel(Uint8List imageBytes) {
    // Decode and resize image to 224x224
    // Normalize pixel values to 0.0-1.0
    // Return in format [1, 224, 224, 3]
    // Implementation depends on your specific model requirements
    throw UnimplementedError('Implement image preprocessing for your model');
  }

  static WasteDetectionResult _processModelOutput(List<double> output) {
    // Find highest confidence class
    double maxConfidence = 0.0;
    int maxIndex = 0;

    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxConfidence) {
        maxConfidence = output[i];
        maxIndex = i;
      }
    }

    final label = _labels![maxIndex];
    final suggestions = _getUpcyclingSuggestions(label);

    return WasteDetectionResult(
      label: label,
      confidence: maxConfidence,
      suggestions: suggestions,
    );
  }
  */

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
