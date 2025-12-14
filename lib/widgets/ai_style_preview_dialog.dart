import 'package:flutter/material.dart';
import '../models/ai_style.dart';

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
            
            // Image Preview with Transformation
            Container(
              height: 400,
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
                    // User's original photo
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
                    
                    // AI Style Transformation Overlay (simulated)
                    if (_showAfter)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: _getStyleGradient(widget.style.category),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getStyleIcon(widget.style.category),
                                  size: 80,
                                  color: const Color(0xFFF8D7C4),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.style.category == 'haircut'
                                      ? '✂️ ${widget.style.styleName} Applied'
                                      : widget.style.category == 'makeup'
                                          ? '💄 ${widget.style.styleName} Applied'
                                          : '🎨 ${widget.style.styleName} Applied',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
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
            
            // Style Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.style.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
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
                            color: const Color(0xFFF8D7C4).withValues(alpha: 0.2),
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
    );
  }

  List<Color> _getStyleGradient(String category) {
    switch (category) {
      case 'haircut':
        return [
          const Color(0xFFA855F7).withValues(alpha: 0.3),
          const Color(0xFF6366F1).withValues(alpha: 0.4),
        ];
      case 'makeup':
        return [
          const Color(0xFFF8D7C4).withValues(alpha: 0.4),
          const Color(0xFFEC4899).withValues(alpha: 0.5),
        ];
      case 'hair_color':
        return [
          const Color(0xFFFBBF24).withValues(alpha: 0.4),
          const Color(0xFFF59E0B).withValues(alpha: 0.5),
        ];
      default:
        return [
          const Color(0xFFA855F7).withValues(alpha: 0.3),
          const Color(0xFFF8D7C4).withValues(alpha: 0.3),
        ];
    }
  }

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
}
