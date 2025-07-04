# TensorFlow Lite Integration Guide

## Current Status

The EcoCura Flutter app is currently using **mock data** for ML inference instead of the actual TensorFlow Lite model. This document explains why and how to enable real ML functionality.

## Why TensorFlow Lite is Currently Disabled

### 1. Web Browser Limitations ❌

**TensorFlow Lite does NOT work in web browsers** for the following technical reasons:

- **Native Library Dependency**: TensorFlow Lite is designed for mobile/embedded devices and requires native C++ libraries
- **Browser Security**: Web browsers cannot access native system libraries for security reasons
- **Runtime Environment**: JavaScript/WebAssembly has different runtime requirements than native mobile apps
- **Memory Management**: TensorFlow Lite's memory management is incompatible with browser sandboxing

### 2. Package Stability Issues

The `tflite_flutter` package has been temporarily disabled due to:
- Compatibility issues with recent Flutter versions
- Build conflicts on certain platforms
- Dependency resolution problems

## Platform Support Matrix

| Platform | TensorFlow Lite Support | Current Status | Alternative |
|----------|------------------------|----------------|-------------|
| **Android** | ✅ Full Support | Mock Data | Enable tflite_flutter |
| **iOS** | ✅ Full Support | Mock Data | Enable tflite_flutter |
| **Web** | ❌ Not Supported | Mock Data | Use TensorFlow.js |
| **Desktop** | ⚠️ Limited | Mock Data | Use TensorFlow.js |

## How to Enable TensorFlow Lite (Mobile Only)

### Step 1: Enable the Package

Uncomment the TensorFlow Lite package in `pubspec.yaml`:

```yaml
dependencies:
  # ML & AI
  tflite_flutter: ^0.10.4  # Uncomment this line
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Update ML Service

The ML service (`lib/core/services/ml_service_enhanced.dart`) is already prepared for TensorFlow Lite integration. You'll need to:

1. Load the model from `assets/ml_models/model.tflite`
2. Replace mock inference with real model inference
3. Handle model input/output tensors

### Step 4: Test on Mobile Devices

```bash
# Test on Android
flutter run -d android

# Test on iOS
flutter run -d ios
```

## Web Alternative: TensorFlow.js

For web support, consider implementing TensorFlow.js:

### Option 1: TensorFlow.js Package

```yaml
dependencies:
  tensorflow_lite_flutter_web: ^0.1.0  # Alternative web package
```

### Option 2: Custom JavaScript Integration

1. Convert your `.tflite` model to TensorFlow.js format
2. Load the model using JavaScript
3. Create a Flutter web plugin to interface with the JS model

## Current Mock Data Behavior

The app currently returns realistic mock results:

- **Categories**: Plastic Bottles, Wood, Cardboard, Tin Cans
- **Confidence**: Random values between 85-99%
- **Clean Labels**: No count prefixes (fixed "0 bottle" → "bottle")
- **Suggestions**: Real upcycling project ideas

## Model Files

Your TensorFlow Lite model files are ready in:
- `assets/ml_models/model.tflite` - The trained model
- `assets/ml_models/labels.txt` - Category labels

## Debugging ML Issues

The ML service includes comprehensive logging:

```dart
// Enable debug logging
const bool kDebugMode = true;
```

Debug output includes:
- Platform detection (Web vs Mobile)
- Model loading status
- Inference results
- Error messages

## Recommended Next Steps

1. **For Mobile Development**: Enable TensorFlow Lite package and test on physical devices
2. **For Web Development**: Implement TensorFlow.js alternative
3. **For Production**: Use platform-specific builds (mobile with TensorFlow Lite, web with TensorFlow.js)

## Performance Considerations

- **Mobile**: TensorFlow Lite provides excellent performance on mobile devices
- **Web**: TensorFlow.js performance varies by browser and device
- **Hybrid**: Consider server-side inference for consistent performance across platforms

## Troubleshooting

### Common Issues:

1. **Build Errors**: Ensure Flutter and dependencies are up to date
2. **Model Loading**: Verify model files are in the correct assets folder
3. **Platform Errors**: Test on actual devices, not just simulators
4. **Memory Issues**: Monitor memory usage during inference

### Getting Help:

- Check Flutter logs: `flutter logs`
- Enable verbose logging: `flutter run -v`
- Test on multiple devices and platforms
