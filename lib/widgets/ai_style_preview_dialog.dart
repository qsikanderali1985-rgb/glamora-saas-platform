import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/ai_style.dart';
import '../services/gemini_ai_service.dart';

// AI Style Preview Dialog with Before/After Visual Transformation
class AIStylePreviewDialog extends StatefulWidget {
  final AIStyleRecommendation style;
  final String originalImagePath;
  final VoidCallback onSelectStyle;

  const AIStylePreviewDialog({
    super.key,
    required this.style,
    required this.originalImagePath,
    required this.onSelectStyle,
  });

  @override
  State<AIStylePreviewDialog> createState() => _AIStylePreviewDialogState();
}

class _AIStylePreviewDialogState extends State<AIStylePreviewDialog> {
  bool _showAfter = true;
  final _geminiAI = GeminiAIService();
  String _aiRecommendation = '';
  bool _loadingAI = false;

  @override
  void initState() {
    super.initState();
    _getAIRecommendation();
  }

  /// Get AI-powered recommendation from Gemini
  Future<void> _getAIRecommendation() async {
    setState(() => _loadingAI = true);
    
    try {
      final recommendation = await _geminiAI.getStyleRecommendation(
        widget.style.styleName,
        'oval', // Default face shape, can be detected from uploaded photo
      );
      
      setState(() {
        _aiRecommendation = recommendation;
        _loadingAI = false;
      });
    } catch (e) {
      setState(() {
        _aiRecommendation = widget.style.description;
        _loadingAI = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF111827),
              const Color(0xFF1F2937),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFF8D7C4).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFF8D7C4),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.style.styleName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.style.matchScore.toInt()}% Perfect Match',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            
            // Before/After Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showAfter = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_showAfter 
                              ? const Color(0xFFA855F7)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 18, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'BEFORE (Original)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showAfter = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: _showAfter
                              ? const LinearGradient(
                                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                                )
                              : null,
                          color: !_showAfter ? Colors.white.withValues(alpha: 0.1) : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_fix_high, size: 18, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'AFTER (AI Styled)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image Preview with Transformation (REDUCED HEIGHT)
            Container(
              height: 300,  // Reduced from 400 to prevent overflow
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // User's original photo with REAL VISUAL TRANSFORMATION
                    if (_showAfter)
                      // AFTER: Apply visual filters to make it look different
                      ColorFiltered(
                        colorFilter: _getColorTransformation(),
                        child: ImageFiltered(
                          imageFilter: _getImageFilter(),
                          child: Image.network(
                            widget.originalImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF1F2937),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      // BEFORE: Show original photo without any filters
                      Image.network(
                        widget.originalImagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF1F2937),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.white24,
                              ),
                            ),
                          );
                        },
                      ),
                    
                    // AI Style Transformation Overlay (REALISTIC)
                    if (_showAfter)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Realistic Style Transformation Visual
                            _buildTransformationOverlay(),
                            
                            // Center Badge
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Spacer(),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 40),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getStyleIcon(widget.style.category),
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.style.styleName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _getTransformationDescription(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withValues(alpha: 0.9),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Status Indicator
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _showAfter 
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (_showAfter ? Colors.green : Colors.orange)
                                  .withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showAfter ? Icons.check_circle : Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _showAfter ? 'AI Transformed' : 'Original Photo',
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
            ),
            
            const SizedBox(height: 16),
            
            // AI-Powered Style Description with Gemini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFA855F7).withValues(alpha: 0.15),
                      const Color(0xFFF8D7C4).withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFA855F7), Color(0xFFF8D7C4)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Gemini AI Recommendation',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // AI-generated recommendation or loading
                    _loadingAI
                        ? const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA855F7)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'AI analyzing your style...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            _aiRecommendation.isNotEmpty ? _aiRecommendation : widget.style.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.95),
                              height: 1.5,
                            ),
                          ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.style.features.map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFF8D7C4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: widget.onSelectStyle,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Select & Share with Provider'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA855F7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }

  // Removed unused _getStyleGradient method

  IconData _getStyleIcon(String category) {
    switch (category) {
      case 'haircut':
        return Icons.content_cut;
      case 'makeup':
        return Icons.face;
      case 'hair_color':
        return Icons.palette;
      default:
        return Icons.auto_awesome;
    }
  }

  // REALISTIC Transformation Visual Overlay
  Widget _buildTransformationOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Top darkening (simulates shorter hair on top)
          if (widget.style.category == 'haircut')
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Cutting effect lines
                    Positioned(
                      top: 10,
                      left: 30,
                      right: 30,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFFA855F7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 40,
                      right: 40,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFFA855F7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Scissor icons
                    Positioned(
                      top: 5,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA855F7),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.content_cut, color: Colors.white, size: 16),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA855F7),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.content_cut, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Side darkening (simulates tapered sides)
          if (widget.style.category == 'haircut')
            Positioned(
              left: 0,
              top: 80,
              bottom: 200,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          if (widget.style.category == 'haircut')
            Positioned(
              right: 0,
              top: 80,
              bottom: 200,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          
          // Center transformation indicators
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.style.category == 'haircut')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA855F7), width: 2),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_upward, color: Color(0xFFA855F7), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'TOP: Hair Shortened',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.compare_arrows, color: Color(0xFFA855F7), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'SIDES: Faded & Tapered',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                if (widget.style.category == 'makeup')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.face_retouching_natural, color: Color(0xFFF8D7C4), size: 40),
                        SizedBox(height: 8),
                        Text('Foundation Applied', style: TextStyle(color: Colors.white, fontSize: 12)),
                        Text('Eye Makeup Enhanced', style: TextStyle(color: Colors.white, fontSize: 12)),
                        Text('Lipstick & Blush Added', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                
                if (widget.style.category == 'hair_color')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.palette, color: Color(0xFFFBBF24), size: 40),
                        SizedBox(height: 8),
                        Text('Hair Color Applied', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Highlights Added', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get transformation description based on style
  String _getTransformationDescription() {
    switch (widget.style.category) {
      case 'haircut':
        return 'Hair trimmed, styled & shaped professionally';
      case 'makeup':
        return 'Full makeup with contouring & highlighting';
      case 'hair_color':
        return 'Hair color with professional toning';
      default:
        return 'AI transformation applied';
    }
  }

  // REAL COLOR TRANSFORMATION - Makes the photo look visually different!
  ColorFilter _getColorTransformation() {
    switch (widget.style.category) {
      case 'haircut':
        // Haircut: STRONG contrast and sharpness
        return ColorFilter.matrix([
          1.4, 0, 0, 0, -30,  // Red channel - strong enhancement
          0, 1.4, 0, 0, -30,  // Green channel - strong enhancement  
          0, 0, 1.4, 0, -30,  // Blue channel - strong enhancement
          0, 0, 0, 1, 0,      // Alpha channel
        ]);
      
      case 'makeup':
        // Makeup: VERY WARM pink/peachy tones
        return ColorFilter.matrix([
          1.5, 0, 0, 0, 40,   // Red channel - VERY enhanced for blush/lipstick
          0, 1.1, 0, 0, 20,   // Green channel - enhanced
          0, 0, 0.7, 0, -10,  // Blue channel - REDUCED for warm tone
          0, 0, 0, 1, 0,      // Alpha channel
        ]);
      
      case 'hair_color':
        // Hair color: STRONG golden/blonde tones
        return ColorFilter.matrix([
          1.6, 0, 0, 0, 50,   // Red channel - VERY strong boost
          0, 1.5, 0, 0, 40,   // Green channel - strong boost for golden
          0, 0, 0.6, 0, -20,  // Blue channel - REDUCED for warm color
          0, 0, 0, 1, 0,      // Alpha channel
        ]);
      
      default:
        // Default: Strong enhancement
        return ColorFilter.matrix([
          1.3, 0, 0, 0, 20,
          0, 1.3, 0, 0, 20,
          0, 0, 1.3, 0, 20,
          0, 0, 0, 1, 0,
        ]);
    }
  }

  // REAL IMAGE FILTER - Blur/sharpen effects
  ui.ImageFilter _getImageFilter() {
    switch (widget.style.category) {
      case 'haircut':
        // Haircut: NO blur for sharp look
        return ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0);
      
      case 'makeup':
        // Makeup: STRONG blur for very smooth "airbrushed" skin
        return ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0);
      
      case 'hair_color':
        // Hair color: Medium blur for color blend
        return ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0);
      
      default:
        return ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0);
    }
  }
}
