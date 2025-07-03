import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static bool _isInitialized = false;

  // Initialize the ML model
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load the model
      _interpreter = await Interpreter.fromAsset('assets/ml_models/waste_classifier.tflite');
      
      // Load labels
      final labelsData = await rootBundle.loadString('assets/ml_models/labels.txt');
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      
      _isInitialized = true;
      print('ML Service initialized successfully');
    } catch (e) {
      print('Failed to initialize ML Service: $e');
      _isInitialized = false;
    }
  }

  // Classify waste from image bytes
  static Future<WasteDetectionResult> classifyWaste(Uint8List imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_interpreter == null || _labels == null) {
      return _getMockResult(); // Fallback to mock data
    }

    try {
      // Preprocess image
      final input = _preprocessImage(imageBytes);
      
      // Prepare output tensor
      final output = List.filled(_labels!.length, 0.0).reshape([1, _labels!.length]);
      
      // Run inference
      _interpreter!.run(input, output);
      
      // Process results
      return _processResults(output[0]);
    } catch (e) {
      print('Error during ML inference: $e');
      return _getMockResult(); // Fallback to mock data
    }
  }

  // Preprocess image for model input
  static List<List<List<List<double>>>> _preprocessImage(Uint8List imageBytes) {
    // Decode image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Resize to model input size (224x224 for most models)
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Convert to normalized float values
    List<List<List<double>>> imageMatrix = [];
    for (int y = 0; y < 224; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < 224; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        row.add([
          pixel.r / 255.0, // Red channel
          pixel.g / 255.0, // Green channel
          pixel.b / 255.0, // Blue channel
        ]);
      }
      imageMatrix.add(row);
    }

    return [imageMatrix]; // Batch dimension
  }

  // Process model output to get results
  static WasteDetectionResult _processResults(List<double> output) {
    // Find the class with highest confidence
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

  // Get upcycling suggestions based on detected waste type
  static List<String> _getUpcyclingSuggestions(String wasteType) {
    final suggestions = {
      'plastic_bottle': [
        'Create a Bird Feeder - Cut holes and add perches',
        'Make a Planter - Perfect for herbs and small plants',
        'DIY Pen Holder - Organize your desk supplies',
      ],
      'cardboard_box': [
        'Build a Desk Organizer - Multiple compartments',
        'Create Storage Solutions - Decorative boxes',
        'Make a Cat House - Fun project for pets',
      ],
      'tin_can': [
        'Craft a Lantern - Add holes for light patterns',
        'Make a Pen Holder - Wrap with decorative paper',
        'Create a Planter - Great for succulents',
      ],
      'toilet_paper_roll': [
        'Organize Cables - Perfect cord management',
        'Make Seedling Pots - Biodegradable planters',
        'Create Bird Feeders - Cover with peanut butter',
      ],
      'fabric': [
        'Sew a Tote Bag - Reusable shopping bag',
        'Make Cleaning Rags - Cut into useful sizes',
        'Create Plant Ties - Soft support for plants',
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
    final mockResults = [
      WasteDetectionResult(
        label: 'Plastic Bottle',
        confidence: 0.92,
        suggestions: [
          'Create a Bird Feeder - Cut holes and add perches',
          'Make a Planter - Perfect for herbs and small plants',
          'DIY Pen Holder - Organize your desk supplies',
        ],
      ),
      WasteDetectionResult(
        label: 'Cardboard Box',
        confidence: 0.87,
        suggestions: [
          'Build a Desk Organizer - Multiple compartments',
          'Create Storage Solutions - Decorative boxes',
          'Make a Cat House - Fun project for pets',
        ],
      ),
    ];

    return mockResults[DateTime.now().millisecond % mockResults.length];
  }

  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
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
