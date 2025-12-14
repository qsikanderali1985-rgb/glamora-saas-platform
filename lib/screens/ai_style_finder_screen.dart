import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ai_style.dart';

class AIStyleFinderScreen extends StatefulWidget {
  const AIStyleFinderScreen({super.key});

  @override
  State<AIStyleFinderScreen> createState() => _AIStyleFinderScreenState();
}

class _AIStyleFinderScreenState extends State<AIStyleFinderScreen> {
  String? _uploadedImagePath;
  FaceAnalysisResult? _analysisResult;
  List<AIStyleRecommendation> _recommendations = [];
  List<AIStyleRecommendation> _selectedStyles = [];
  bool _isAnalyzing = false;
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('AI Style Finder'),
          ],
        ),
      ),
      body: _uploadedImagePath == null
          ? _buildUploadSection()
          : _buildResultsSection(),
      bottomNavigationBar: _selectedStyles.isNotEmpty
          ? _buildBottomActionBar()
          : null,
    );
  }

  Widget _buildUploadSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // AI Icon Animation
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF8D7C4).withValues(alpha: 0.2),
                  const Color(0xFFA855F7).withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          const Text(
            'AI-Powered Style Recommendations',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Upload your photo and let our AI analyze your face shape, skin tone, and features to suggest the perfect styles for you!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Features
          _buildFeatureCard(
            Icons.face,
            'Face Analysis',
            'AI detects your face shape, skin tone, and features',
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            Icons.auto_fix_high,
            'Smart Suggestions',
            'Get personalized haircut, makeup & color recommendations',
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            Icons.check_circle,
            'Match Score',
            'Each style comes with a compatibility score',
          ),
          
          const SizedBox(height: 40),
          
          // Upload Button
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload_file, size: 24),
            label: const Text(
              'Upload Your Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ).wrapWithGradient(),
          
          const SizedBox(height: 16),
          
          Text(
            'Supported formats: JPG, PNG\nBest results with clear, front-facing photos',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_isAnalyzing) {
      return _buildAnalyzingLoader();
    }

    return Column(
      children: [
        _buildPhotoAndAnalysis(),
        _buildCategoryFilter(),
        Expanded(
          child: _buildRecommendations(),
        ),
      ],
    );
  }

  Widget _buildAnalyzingLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Analyzing Your Photo...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'AI is detecting your features',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoAndAnalysis() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Uploaded Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 100,
              color: const Color(0xFF111827),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Color(0xFFF8D7C4),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Analysis Results
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Analysis Complete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_analysisResult != null) ...[
                  _buildAnalysisTag('Face: ${_analysisResult!.faceShape}'),
                  const SizedBox(height: 4),
                  _buildAnalysisTag('Skin: ${_analysisResult!.skinTone}'),
                  const SizedBox(height: 4),
                  _buildAnalysisTag('Hair: ${_analysisResult!.hairType}'),
                ],
              ],
            ),
          ),
          
          IconButton(
            onPressed: _retakePhoto,
            icon: const Icon(Icons.refresh, color: Color(0xFFF8D7C4)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8D7C4).withValues(alpha: 0.3),
            const Color(0xFFA855F7).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      {'id': 'all', 'label': 'All', 'icon': Icons.dashboard},
      {'id': 'haircut', 'label': 'Haircut', 'icon': Icons.content_cut},
      {'id': 'makeup', 'label': 'Makeup', 'icon': Icons.face},
      {'id': 'hair_color', 'label': 'Color', 'icon': Icons.palette},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['id'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat['id'] as String;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                      )
                    : null,
                color: isSelected ? null : const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.white60,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendations() {
    final filteredRecs = _selectedCategory == 'all'
        ? _recommendations
        : _recommendations.where((r) => r.category == _selectedCategory).toList();

    if (filteredRecs.isEmpty) {
      return Center(
        child: Text(
          'No recommendations for this category',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRecs.length,
      itemBuilder: (context, index) {
        final style = filteredRecs[index];
        final isSelected = _selectedStyles.contains(style);
        return _buildStyleCard(style, isSelected);
      },
    );
  }

  Widget _buildStyleCard(AIStyleRecommendation style, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSelected
              ? [
                  const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                  const Color(0xFFA855F7).withValues(alpha: 0.3),
                ]
              : [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFA855F7)
              : Colors.white.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Image placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF111827).withValues(alpha: 0.8),
                  const Color(0xFF111827).withValues(alpha: 0.6),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    _getCategoryIcon(style.category),
                    size: 60,
                    color: const Color(0xFFF8D7C4).withValues(alpha: 0.5),
                  ),
                ),
                // Match Score Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${style.matchScore.toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        style.styleName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(style.difficulty).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _getDifficultyColor(style.difficulty)),
                      ),
                      child: Text(
                        style.difficulty.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getDifficultyColor(style.difficulty),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  style.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Features
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: style.features.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8D7C4).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFF8D7C4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${style.estimatedTime} min',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rs ${style.estimatedPrice.toInt()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (isSelected) {
                            _selectedStyles.remove(style);
                          } else {
                            _selectedStyles.add(style);
                          }
                        });
                      },
                      icon: Icon(
                        isSelected ? Icons.check_circle : Icons.add_circle_outline,
                        size: 18,
                      ),
                      label: Text(isSelected ? 'Selected' : 'Select'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.green
                            : const Color(0xFFA855F7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final totalPrice = _selectedStyles.fold(0.0, (sum, s) => sum + s.estimatedPrice);
    final totalTime = _selectedStyles.fold(0, (sum, s) => sum + s.estimatedTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF111827).withValues(alpha: 0.98),
            const Color(0xFF111827).withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedStyles.length} Style${_selectedStyles.length > 1 ? 's' : ''} Selected',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Rs $totalPrice',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF8D7C4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' • $totalTime min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _proceedToBooking,
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ).wrapWithGradient(),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'haircut':
        return Icons.content_cut;
      case 'makeup':
        return Icons.face;
      case 'hair_color':
        return Icons.palette;
      default:
        return Icons.spa;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _pickImage() async {
    // Open file browser to select image
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        // User cancelled the picker
        return;
      }

      // Image selected successfully
      setState(() {
        _uploadedImagePath = image.path;
        _isAnalyzing = true;
      });

      // Simulate AI processing
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
            _analysisResult = FaceAnalysisResult.analyze(_uploadedImagePath!);
            _recommendations = _analysisResult!.getRecommendations();
          });
        }
      });
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _retakePhoto() {
    setState(() {
      _uploadedImagePath = null;
      _analysisResult = null;
      _recommendations = [];
      _selectedStyles = [];
      _selectedCategory = 'all';
    });
  }

  void _proceedToBooking() {
    if (_selectedStyles.isEmpty) return;

    final selection = CustomerStyleSelection(
      customerId: 'current_user_id',
      customerPhotoUrl: _uploadedImagePath!,
      analysisResult: _analysisResult!,
      selectedStyles: _selectedStyles,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, selection);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedStyles.length} style(s) added to your booking!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Extension to wrap button with gradient
extension GradientButtonExtension on Widget {
  Widget wrapWithGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: this,
    );
  }
}
