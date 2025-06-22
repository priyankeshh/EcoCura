import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/ml_service.dart';
import '../../../../shared/models/waste_category_model.dart';
import '../widgets/ml_result_screen.dart';
import '../widgets/upcycling_process_screen.dart';

class UpcycleScreen extends ConsumerStatefulWidget {
  const UpcycleScreen({super.key});

  @override
  ConsumerState<UpcycleScreen> createState() => _UpcycleScreenState();
}

class _UpcycleScreenState extends ConsumerState<UpcycleScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
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
        setState(() {
          _selectedImage = File(image.path);
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
        setState(() {
          _selectedImage = File(image.path);
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
      final mlService = MLService();
      await mlService.initialize();

      // Analyze the image using ML service
      final result = await mlService.analyzeImage(File(image.path));

      // Format the result for display
      final formattedResult = '${result.label} - ${result.suggestions.first}';

      setState(() {
        _analysisResult = formattedResult;
        _isAnalyzing = false;
      });

      // Navigate to results screen
      if (mounted) {
        _showResultsScreen();
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

  void _showResultsScreen() {
    if (_selectedImage != null && _analysisResult != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MLResultScreen(
            image: _selectedImage!,
            result: _analysisResult!,
            onProjectSelected: _navigateToProject,
          ),
        ),
      );
    }
  }

  void _navigateToProject(UpcyclingProject project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpcyclingProcessScreen(project: project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpCycle'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.05),
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

              // Selected Image or Recycling Image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/plastic-recycling.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.lightGreen.withOpacity(0.3),
                              child: const Icon(
                                Icons.recycling,
                                size: 60,
                                color: AppTheme.primaryGreen,
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: 40),

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
                    // Photo Library Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Photo Library'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.9),
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
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.9),
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
                          side: BorderSide(color: AppTheme.primaryGreen),
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
    );
  }
}
