import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' show base64Encode;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/provider.dart';

/// FREE Google Gemini AI Image Generator
/// Opens Gemini with pre-filled prompts for different beauty styles
class GeminiAIGeneratorScreen extends StatefulWidget {
  const GeminiAIGeneratorScreen({super.key});

  @override
  State<GeminiAIGeneratorScreen> createState() => _GeminiAIGeneratorScreenState();
}

class _GeminiAIGeneratorScreenState extends State<GeminiAIGeneratorScreen> {
  String _selectedCategory = 'haircut';
  String? _uploadedAIImage; // Store uploaded AI-generated image
  bool _hasGeneratedImage = false; // Track if user has generated images
  
  // Pre-defined prompts for each category
  final Map<String, Map<String, dynamic>> _prompts = {
    'haircut': {
      'title': 'Hairstyle Transformations',
      'icon': Icons.content_cut,
      'prompt': '''Generate 3 professional hairstyle variations for this person:

1. ANALYZE their face shape, current hair length, and facial features
2. CREATE 3 distinct hairstyle images:
   • SHORT STYLE: Modern fade with textured top, styled professionally
   • MEDIUM STYLE: Layered cut with volume and movement
   • LONG STYLE: Flowing layers with face-framing pieces

3. Each image should show:
   - Front-facing view
   - Professional salon-quality styling
   - Appropriate for their face shape and features
   - Realistic, natural-looking transformation

Make the transformations look like professional salon results. Show clear before/after differences so the customer can choose their favorite and share it with their stylist!''',
    },
    'makeup': {
      'title': 'Makeup Looks',
      'icon': Icons.face,
      'prompt': '''Generate 3 professional makeup looks for this person:

1. ANALYZE their skin tone, face shape, and features
2. CREATE 3 different makeup styles:
   • NATURAL/DAY: Subtle enhancement, glowing skin, natural tones
   • GLAMOROUS/EVENING: Bold eyes, defined lips, dramatic but elegant
   • SPECIAL OCCASION: Full glam with contouring, highlighting, statement makeup

3. Each image should show:
   - Clear makeup application
   - Appropriate for their skin tone
   - Professional makeup artist quality
   - Realistic, wearable looks

Make each look distinct and beautiful. Show transformations that a professional makeup artist would create!''',
    },
    'hair_color': {
      'title': 'Hair Color Transformations',
      'icon': Icons.palette,
      'prompt': '''Generate 3 professional hair color variations for this person:

1. ANALYZE their current hair color, skin tone, and eye color
2. CREATE 3 different hair color transformations:
   • WARM TONES: Honey blonde, caramel, or auburn (choose based on skin tone)
   • COOL TONES: Ash brown, platinum, or silver (choose based on skin tone)
   • BOLD/FASHION: Vibrant color or balayage/ombre (trendy and modern)

3. Each image should show:
   - Natural-looking color application
   - Professional colorist quality
   - Flattering for their complexion
   - Realistic hair color transformation

Make the colors look professionally done by a skilled colorist. Show how different shades complement their features!''',
    },
    'beard': {
      'title': 'Beard Styles',
      'icon': Icons.face_retouching_natural,
      'prompt': '''Generate 3 professional beard style variations for this person:

1. ANALYZE their face shape and facial features
2. CREATE 3 different beard styles:
   • CLEAN GROOMED: Short, well-maintained beard with sharp edges
   • FULL BEARD: Medium length, styled and shaped professionally
   • DESIGNER STUBBLE: 3-5 day growth, perfectly shaped and maintained

3. Each image should show:
   - Professional grooming quality
   - Appropriate for their face shape
   - Well-defined lines and shape
   - Realistic, natural-looking facial hair

Make each style look professionally groomed by a skilled barber. Show clear differences between styles!''',
    },
  };

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
                  colors: [Color(0xFF4285F4), Color(0xFF34A853), Color(0xFFFBBC05), Color(0xFFEA4335)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gemini AI Generator', style: TextStyle(fontSize: 18)),
                Text('FREE - Powered by Google', style: TextStyle(fontSize: 10, color: Color(0xFF34A853))),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF34A853), Color(0xFFFBBC05), Color(0xFFEA4335)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    '100% FREE AI Image Generation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Powered by Google Gemini - No API costs, No subscriptions!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // How it Works
            const Text(
              'How It Works',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildStep('1', 'Choose Your Style', 'Select hairstyle, makeup, color, or beard style'),
            const SizedBox(height: 12),
            _buildStep('2', 'Open Gemini AI', 'We\'ll open Google Gemini with pre-filled prompt'),
            const SizedBox(height: 12),
            _buildStep('3', 'Upload Photo', 'Upload your photo in Gemini (it will ask you)'),
            const SizedBox(height: 12),
            _buildStep('4', 'Get AI Images', 'Gemini generates 3 professional style variations'),
            const SizedBox(height: 12),
            _buildStep('5', 'Download & Share', 'Save your favorite and share with provider'),
            
            const SizedBox(height: 32),
            
            // Category Selection
            const Text(
              'Choose Your Transformation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Category Cards
            _buildCategoryCard('haircut'),
            const SizedBox(height: 12),
            _buildCategoryCard('makeup'),
            const SizedBox(height: 12),
            _buildCategoryCard('hair_color'),
            const SizedBox(height: 12),
            _buildCategoryCard('beard'),
            
            const SizedBox(height: 32),
            
            // Generate Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF34A853), Color(0xFFFBBC05), Color(0xFFEA4335)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4285F4).withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _openGeminiWithPrompt,
                icon: const Icon(Icons.auto_awesome, size: 28),
                label: const Text(
                  'Generate AI Images (FREE)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            
            // STEP 2: Upload Generated Image
            if (_hasGeneratedImage) ...[
              const SizedBox(height: 32),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 32),
              
              const Text(
                'Upload Your AI-Generated Image',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              if (_uploadedAIImage == null)
                // Upload Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4285F4), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload, size: 64, color: Color(0xFF4285F4)),
                      const SizedBox(height: 16),
                      const Text(
                        'Upload the AI image you saved from Gemini',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _uploadAIGeneratedImage,
                        icon: const Icon(Icons.file_upload),
                        label: const Text('Select Image from Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Show uploaded image
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF34A853), width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          _uploadedAIImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.image, size: 64, color: Colors.white24),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _uploadedAIImage = null;
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Change Image'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white24),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _shareWithProvider,
                            icon: const Icon(Icons.send),
                            label: const Text('Share with Provider'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF34A853),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4285F4), Color(0xFF34A853)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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

  Widget _buildCategoryCard(String category) {
    final data = _prompts[category]!;
    final isSelected = _selectedCategory == category;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                )
              : null,
          color: isSelected ? null : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                data['icon'] as IconData,
                size: 32,
                color: isSelected ? Colors.white : const Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                data['title'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Future<void> _openGeminiWithPrompt() async {
    // Google Gemini URL - user will copy prompt from dialog
    final geminiUrl = 'https://gemini.google.com/app?hl=en';
    
    try {
      final uri = Uri.parse(geminiUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        // Mark that user has started generation process
        setState(() {
          _hasGeneratedImage = true;
        });
        
        // Show detailed instructions
        if (mounted) {
          _showInstructionsDialog();
        }
      } else {
        throw 'Could not launch Gemini';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open Gemini: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Upload AI-generated image from gallery
  Future<void> _uploadAIGeneratedImage() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return;

      // Convert to base64 for web or use path for mobile
      String imagePath;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        imagePath = 'data:image/png;base64,${base64Encode(bytes)}';
      } else {
        imagePath = image.path;
      }

      setState(() {
        _uploadedAIImage = imagePath;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI image uploaded successfully! Now share it with a provider.'),
            backgroundColor: Color(0xFF34A853),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Share AI image with service provider
  void _shareWithProvider() {
    if (_uploadedAIImage == null) return;
    
    // Show provider selection dialog
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Share AI Style with Provider',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _getDemoProviders().length,
                    itemBuilder: (context, index) {
                      final provider = _getDemoProviders()[index];
                      return _buildProviderTile(provider);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // Get demo providers (in real app, fetch from database)
  List<ServiceProvider> _getDemoProviders() {
    return [
      ServiceProvider(
        id: '1',
        name: 'Glow Beauty Salon',
        type: 'salon',
        address: 'F-7 Markaz, Islamabad',
        latitude: 33.7294,
        longitude: 73.0931,
        rating: 4.9,
        totalReviews: 342,
        imageUrl: '',
        services: ['Haircut', 'Hair Color', 'Facial', 'Bridal Makeup'],
        isVerified: true,
        isOpen: true,
        openingTime: '10:00 AM',
        closingTime: '8:00 PM',
        distance: 0.8,
        hasHomeService: true,
        deliveryFee: 500,
        minBookingTime: 30,
        specialities: ['Bridal Makeup', 'Hair Spa', 'Keratin Treatment'],
      ),
      ServiceProvider(
        id: '2',
        name: 'Elite Gentleman Barber',
        type: 'barber',
        address: 'G-11 Markaz, Islamabad',
        latitude: 33.6844,
        longitude: 73.0479,
        rating: 4.7,
        totalReviews: 456,
        imageUrl: '',
        services: ['Haircut', 'Beard Trim', 'Shaving', 'Hair Color'],
        isVerified: true,
        isOpen: true,
        openingTime: '9:00 AM',
        closingTime: '9:00 PM',
        distance: 1.5,
        hasHomeService: true,
        deliveryFee: 300,
        minBookingTime: 20,
        specialities: ['Classic Shave', 'Fade Haircut', 'Beard Styling'],
      ),
      ServiceProvider(
        id: '3',
        name: 'Charm Beauty Lounge',
        type: 'salon',
        address: 'F-11 Markaz, Islamabad',
        latitude: 33.6813,
        longitude: 73.0425,
        rating: 4.7,
        totalReviews: 234,
        imageUrl: '',
        services: ['Hair Spa', 'Keratin', 'Rebonding', 'Hair Color'],
        isVerified: true,
        isOpen: true,
        openingTime: '10:00 AM',
        closingTime: '8:00 PM',
        distance: 1.8,
        hasHomeService: true,
        deliveryFee: 500,
        minBookingTime: 60,
        specialities: ['Brazilian Blowout', 'Ombre Hair', 'Balayage'],
      ),
    ];
  }
  
  Widget _buildProviderTile(ServiceProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close bottom sheet
        _confirmShareWithProvider(provider);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                provider.type == 'barber' ? Icons.face_retouching_natural : Icons.spa,
                size: 32,
                color: const Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.address,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFBBC05)),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.rating} (${provider.totalReviews} reviews)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF4285F4), size: 16),
          ],
        ),
      ),
    );
  }
  
  void _confirmShareWithProvider(ServiceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text(
          'Share AI Style',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your AI-generated style will be shared with:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, color: Color(0xFF34A853)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      provider.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'They will receive your AI image and can prepare materials & timing accordingly.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _sendToProvider(provider);
            },
            icon: const Icon(Icons.send),
            label: const Text('Share Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34A853),
            ),
          ),
        ],
      ),
    );
  }
  
  void _sendToProvider(ServiceProvider provider) {
    // In real app: Save to database, send notification to provider
    // For now: Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'AI style shared with ${provider.name}! They will prepare for your appointment.',
        ),
        backgroundColor: const Color(0xFF34A853),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Book Now',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Go back to home
          },
        ),
      ),
    );
  }

  void _showInstructionsDialog() {
    final promptData = _prompts[_selectedCategory]!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF4285F4)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Follow These Steps',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '1. Copy this prompt below',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4285F4)),
                ),
                child: SelectableText(
                  promptData['prompt'] as String,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. In Gemini: Paste prompt and upload your photo',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '3. Wait 10-30 seconds for AI to generate images',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '4. Download your favorite image',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '5. Come back and share with your provider!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It!', style: TextStyle(color: Color(0xFF4285F4))),
          ),
        ],
      ),
    );
  }
}
