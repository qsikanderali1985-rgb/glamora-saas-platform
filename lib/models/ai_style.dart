// AI Style Recommendation Model
class AIStyleRecommendation {
  final String id;
  final String category; // haircut, makeup, hair_color, facial
  final String styleName;
  final String description;
  final String imageUrl;
  final double matchScore; // 0-100
  final List<String> features;
  final String difficulty; // easy, medium, hard
  final int estimatedTime; // in minutes
  final double estimatedPrice;

  AIStyleRecommendation({
    required this.id,
    required this.category,
    required this.styleName,
    required this.description,
    required this.imageUrl,
    required this.matchScore,
    required this.features,
    required this.difficulty,
    required this.estimatedTime,
    required this.estimatedPrice,
  });
}

// Face Analysis Result
class FaceAnalysisResult {
  final String faceShape; // oval, round, square, heart, diamond
  final String skinTone; // fair, medium, olive, tan, deep
  final String hairType; // straight, wavy, curly, coily
  final String hairColor; // black, brown, blonde, red
  final Map<String, String> features; // Additional detected features

  FaceAnalysisResult({
    required this.faceShape,
    required this.skinTone,
    required this.hairType,
    required this.hairColor,
    required this.features,
  });

  // Mock AI Analysis - Replace with actual ML model
  static FaceAnalysisResult analyze(String imagePath) {
    // Simulate AI processing
    return FaceAnalysisResult(
      faceShape: 'oval',
      skinTone: 'medium',
      hairType: 'wavy',
      hairColor: 'brown',
      features: {
        'eyeColor': 'brown',
        'jawline': 'soft',
        'foreheadSize': 'medium',
      },
    );
  }

  // Generate recommendations based on analysis
  List<AIStyleRecommendation> getRecommendations() {
    List<AIStyleRecommendation> recommendations = [];

    // Haircut recommendations
    if (faceShape == 'oval') {
      recommendations.addAll([
        AIStyleRecommendation(
          id: 'h1',
          category: 'haircut',
          styleName: 'Long Layers',
          description: 'Perfect for oval faces - adds movement and dimension',
          imageUrl: 'assets/styles/long_layers.jpg',
          matchScore: 95,
          features: ['Versatile', 'Low Maintenance', 'Elegant'],
          difficulty: 'easy',
          estimatedTime: 45,
          estimatedPrice: 2500,
        ),
        AIStyleRecommendation(
          id: 'h2',
          category: 'haircut',
          styleName: 'Textured Bob',
          description: 'Modern bob with textured ends - highlights your face shape',
          imageUrl: 'assets/styles/textured_bob.jpg',
          matchScore: 92,
          features: ['Trendy', 'Professional', 'Chic'],
          difficulty: 'medium',
          estimatedTime: 60,
          estimatedPrice: 3000,
        ),
      ]);
    }

    // Makeup recommendations based on skin tone
    if (skinTone == 'medium') {
      recommendations.addAll([
        AIStyleRecommendation(
          id: 'm1',
          category: 'makeup',
          styleName: 'Natural Glam',
          description: 'Warm tones perfect for medium skin - glowing natural look',
          imageUrl: 'assets/styles/natural_glam.jpg',
          matchScore: 97,
          features: ['Dewy Finish', 'Bronzed', 'Natural Glow'],
          difficulty: 'easy',
          estimatedTime: 30,
          estimatedPrice: 3500,
        ),
        AIStyleRecommendation(
          id: 'm2',
          category: 'makeup',
          styleName: 'Smokey Eyes',
          description: 'Deep browns and golds - dramatic yet sophisticated',
          imageUrl: 'assets/styles/smokey_eyes.jpg',
          matchScore: 94,
          features: ['Dramatic', 'Evening Look', 'Bold'],
          difficulty: 'medium',
          estimatedTime: 45,
          estimatedPrice: 4500,
        ),
      ]);
    }

    // Hair color recommendations
    if (hairColor == 'brown') {
      recommendations.addAll([
        AIStyleRecommendation(
          id: 'c1',
          category: 'hair_color',
          styleName: 'Caramel Highlights',
          description: 'Warm caramel tones - adds depth and dimension',
          imageUrl: 'assets/styles/caramel_highlights.jpg',
          matchScore: 96,
          features: ['Sun-kissed', 'Natural', 'Brightening'],
          difficulty: 'medium',
          estimatedTime: 120,
          estimatedPrice: 6000,
        ),
        AIStyleRecommendation(
          id: 'c2',
          category: 'hair_color',
          styleName: 'Balayage Blonde',
          description: 'Hand-painted blonde balayage - seamless blend',
          imageUrl: 'assets/styles/balayage.jpg',
          matchScore: 89,
          features: ['Low Maintenance', 'Trendy', 'Dimensional'],
          difficulty: 'hard',
          estimatedTime: 180,
          estimatedPrice: 8500,
        ),
      ]);
    }

    return recommendations;
  }
}

// Customer Style Selection (attached to booking)
class CustomerStyleSelection {
  final String customerId;
  final String customerPhotoUrl;
  final FaceAnalysisResult analysisResult;
  final List<AIStyleRecommendation> selectedStyles;
  final String? additionalNotes;
  final DateTime createdAt;

  CustomerStyleSelection({
    required this.customerId,
    required this.customerPhotoUrl,
    required this.analysisResult,
    required this.selectedStyles,
    this.additionalNotes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerPhotoUrl': customerPhotoUrl,
      'faceShape': analysisResult.faceShape,
      'skinTone': analysisResult.skinTone,
      'hairType': analysisResult.hairType,
      'selectedStyles': selectedStyles.map((s) => {
        'id': s.id,
        'category': s.category,
        'styleName': s.styleName,
        'description': s.description,
        'matchScore': s.matchScore,
        'estimatedPrice': s.estimatedPrice,
        'estimatedTime': s.estimatedTime,
      }).toList(),
      'additionalNotes': additionalNotes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
