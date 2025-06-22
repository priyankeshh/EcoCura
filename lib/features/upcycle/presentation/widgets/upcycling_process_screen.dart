import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/waste_category_model.dart';

class UpcyclingProcessScreen extends StatefulWidget {
  final UpcyclingProject project;

  const UpcyclingProcessScreen({
    super.key,
    required this.project,
  });

  @override
  State<UpcyclingProcessScreen> createState() => _UpcyclingProcessScreenState();
}

class _UpcyclingProcessScreenState extends State<UpcyclingProcessScreen> {
  int _currentStep = 0;
  bool _showAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.05),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Header
              _buildProjectHeader(),

              const SizedBox(height: 24),

              // Materials Needed
              _buildMaterialsSection(),

              const SizedBox(height: 24),

              // Instructions
              _buildInstructionsSection(),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.lightGreen.withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.project.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.build,
                    size: 60,
                    color: AppTheme.primaryGreen,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Project Info
          Text(
            widget.project.name,
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 8),
          Text(
            widget.project.description,
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 12),

          // Project Stats
          Row(
            children: [
              _buildStatChip(
                Icons.schedule,
                widget.project.estimatedTime,
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                Icons.trending_up,
                widget.project.difficulty.displayName,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Materials Needed',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          ...widget.project.materials.map((material) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    material,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step-by-Step Instructions',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          ...widget.project.instructions.asMap().entries.map((entry) {
            final index = entry.key;
            final instruction = entry.value;
            final isCompleted = index < _currentStep;
            final isCurrent = index == _currentStep;

            return _buildInstructionStep(
              index + 1,
              instruction,
              isCompleted,
              isCurrent,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(
    int stepNumber,
    String instruction,
    bool isCompleted,
    bool isCurrent,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Number Circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppTheme.primaryGreen
                  : isCurrent
                      ? AppTheme.primaryGreen.withOpacity(0.2)
                      : Colors.grey[300],
              border: isCurrent
                  ? Border.all(color: AppTheme.primaryGreen, width: 2)
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : Text(
                      stepNumber.toString(),
                      style: TextStyle(
                        color: isCurrent
                            ? AppTheme.primaryGreen
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Instruction Text
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppTheme.primaryGreen.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: isCurrent
                    ? Border.all(color: AppTheme.primaryGreen.withOpacity(0.3))
                    : null,
              ),
              child: Text(
                instruction,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isCompleted
                      ? Colors.grey[600]
                      : AppTheme.textPrimary,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (_currentStep < widget.project.instructions.length)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _currentStep == widget.project.instructions.length - 1
                    ? 'Complete Project'
                    : 'Next Step',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        if (_currentStep >= widget.project.instructions.length) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGreen.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.celebration,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(height: 8),
                Text(
                  'Congratulations!',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'ve completed the ${widget.project.name} project!',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/add-product-listing');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Publish on Store',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryGreen),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Scanner'),
          ),
        ),
      ],
    );
  }
}
