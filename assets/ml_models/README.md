# ML Models Directory

This directory contains machine learning models and related files for the EcoCura app.

## Current Status: PLACEHOLDER IMPLEMENTATION

⚠️ **Important**: The current ML implementation uses mock data and placeholder functions. Real ML models need to be integrated.

## Required ML Models

### 1. Waste Detection Model
- **File**: `waste_detection_model.tflite`
- **Purpose**: Detect and classify different types of waste from camera images
- **Input**: 224x224 RGB image
- **Output**: Classification probabilities for waste categories
- **Categories**: 
  - Plastic Bottle
  - Glass Bottle  
  - Cardboard Box
  - Metal Can
  - Paper
  - Wooden Pallet
  - PVC Pipe
  - Fabric
  - Electronic Waste
  - Organic Waste

### 2. Labels File
- **File**: `labels.txt`
- **Purpose**: Contains the class labels for the waste detection model
- **Format**: One label per line, matching model output indices

## Integration Steps

### Step 1: Prepare the Model
1. Train or obtain a TensorFlow Lite model for waste detection
2. Ensure model input size is 224x224 pixels
3. Convert model to `.tflite` format if needed
4. Test model accuracy and performance

### Step 2: Add Dependencies
Add these dependencies to `pubspec.yaml`:
```yaml
dependencies:
  tflite_flutter: ^0.10.4
  tflite_flutter_helper: ^0.3.1
  image: ^4.0.17
```

### Step 3: Update MLService
Replace the placeholder implementation in `lib/core/services/ml_service.dart`:

```dart
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class MLService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  
  Future<void> initialize() async {
    // Load the model
    _interpreter = await Interpreter.fromAsset('assets/ml_models/waste_detection_model.tflite');
    
    // Load labels
    _labels = await FileUtil.loadLabels('assets/ml_models/labels.txt');
  }
  
  Future<WasteDetectionResult> analyzeImage(File imageFile) async {
    // Preprocess image
    final input = await _preprocessImage(imageFile);
    
    // Run inference
    final output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter!.run(input, output);
    
    // Process results
    return _processResults(output[0]);
  }
}
```

### Step 4: Test Integration
1. Add test images to verify model performance
2. Test with different waste types
3. Validate classification accuracy
4. Optimize inference speed if needed

## Current Placeholder Behavior

The current `MLService` implementation:
- ✅ Simulates 2-second processing time
- ✅ Returns mock classification results
- ✅ Provides realistic confidence scores
- ✅ Includes upcycling suggestions
- ✅ Handles errors gracefully

## Performance Requirements

- **Inference Time**: < 3 seconds on mid-range devices
- **Model Size**: < 50MB for app store optimization
- **Accuracy**: > 85% for common waste types
- **Memory Usage**: < 100MB during inference

## Troubleshooting

### Common Issues:
1. **Model Loading Fails**: Check file path and format
2. **Slow Inference**: Consider model quantization
3. **Poor Accuracy**: Retrain with more diverse dataset
4. **Memory Issues**: Optimize image preprocessing

### Debug Steps:
1. Enable TensorFlow Lite logging
2. Test with known good images
3. Verify input preprocessing
4. Check output tensor shapes

## Future Enhancements

1. **Multi-object Detection**: Detect multiple waste items in one image
2. **Real-time Processing**: Live camera feed analysis
3. **Offline Capability**: Ensure models work without internet
4. **Model Updates**: Over-the-air model updates
5. **Custom Training**: Allow users to improve model with feedback
