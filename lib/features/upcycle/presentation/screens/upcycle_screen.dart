import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/ml_service_enhanced.dart' as MLEnhanced;
import 'scan_results_screen.dart';
import '../../../../core/theme/app_theme.dart';

class UpcycleScreen extends ConsumerStatefulWidget {
  const UpcycleScreen({super.key});

  @override
  ConsumerState<UpcycleScreen> createState() => _UpcycleScreenState();
}

class _UpcycleScreenState extends ConsumerState<UpcycleScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _analysisResult;
  bool _isAnalyzing = false;

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          if (!kIsWeb) {
            _selectedImage = File(image.path);
          }
          _selectedImageBytes = bytes;
        });
        await _processImage(image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing camera: $e')),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          if (!kIsWeb) {
            _selectedImage = File(image.path);
          }
          _selectedImageBytes = bytes;
        });
        await _processImage(image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing gallery: $e')),
        );
      }
    }
  }

  Future<void> _processImage(XFile image) async {
    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      // Initialize ML service if needed
      await MLEnhanced.MLService.initialize();

      // Analyze the image using ML service
      final imageBytes = await image.readAsBytes();
      final result = await MLEnhanced.MLService.classifyWaste(imageBytes);

      // Format the result for display
      final formattedResult = '${result.label} - ${result.suggestions.first}';

      setState(() {
        _analysisResult = formattedResult;
        _isAnalyzing = false;
      });

      // Navigate to results screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanResultsScreen(
              imageBytes: imageBytes,
              result: result,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing image: $e')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with light green background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: const BoxDecoration(
                color: AppTheme.headerColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // EcoCura Logo
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.eco,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Title and subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Scan & UpCycle',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Subtitle
                            const Text(
                              'Scan waste items to discover upcycling possibilities',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withValues(alpha: 0.05),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Educational Text
              Text(
                'Plastic takes 1000 years to decompose...',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Selected Image Display (only show when image is selected)
              if (_selectedImageBytes != null) ...[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _selectedImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // Analysis Status
              if (_isAnalyzing) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                ),
                const SizedBox(height: 16),
                Text(
                  'Analyzing your waste...',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // Action Buttons
              if (!_isAnalyzing) ...[
                Column(
                  children: [
                    // Logo above buttons
                    Container(
                      width: 160,
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.eco,
                                color: Colors.white,
                                size: 80,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Photo Library Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Photo Library'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Camera Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    if (_selectedImage != null) ...[
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                            _analysisResult = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryGreen),
                        ),
                        child: const Text('Clear Image'),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
