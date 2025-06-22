class WasteCategoryModel {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final List<UpcyclingProject> projects;
  final int upcycleCount;

  WasteCategoryModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.projects,
    this.upcycleCount = 0,
  });

  factory WasteCategoryModel.fromMap(Map<String, dynamic> map) {
    return WasteCategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ?? '',
      description: map['description'] ?? '',
      projects: (map['projects'] as List<dynamic>?)
          ?.map((project) => UpcyclingProject.fromMap(project))
          .toList() ?? [],
      upcycleCount: map['upcycleCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'description': description,
      'projects': projects.map((project) => project.toMap()).toList(),
      'upcycleCount': upcycleCount,
    };
  }

  static List<WasteCategoryModel> getDefaultCategories() {
    return [
      WasteCategoryModel(
        id: 'bottles',
        name: 'Bottles',
        imagePath: 'assets/images/bottle.png',
        description: 'Plastic and glass bottles that can be upcycled',
        projects: [
          UpcyclingProject(
            id: 'bird_feeder',
            name: 'Bird Feeder',
            description: 'Create a bird feeder from plastic bottles',
            imagePath: 'assets/images/bird-feeder.png',
            difficulty: ProjectDifficulty.easy,
            estimatedTime: '30 minutes',
            materials: ['Plastic bottle', 'String', 'Bird seeds'],
            instructions: [
              'Clean and dry the plastic bottle thoroughly',
              'Cut feeding ports - mark two or three openings',
              'Create perches - cut two small holes, opposite each other',
              'Decorate the bottle with paint, markers, or decorative tape',
              'Make hanging mechanism - create holes and thread string',
            ],
          ),
          UpcyclingProject(
            id: 'pen_stand',
            name: 'Pen Stand',
            description: 'Transform bottles into desk organizers',
            imagePath: 'assets/images/pen_holder.png',
            difficulty: ProjectDifficulty.easy,
            estimatedTime: '20 minutes',
            materials: ['Plastic bottle', 'Scissors', 'Decorative paper'],
            instructions: [
              'Clean the bottle thoroughly',
              'Cut the bottle to desired height',
              'Sand the edges smooth',
              'Decorate with paper or paint',
              'Add compartments if needed',
            ],
          ),
          UpcyclingProject(
            id: 'vertical_planter',
            name: 'Vertical Planter',
            description: 'Create a vertical garden system',
            imagePath: 'assets/images/vertical-farming.png',
            difficulty: ProjectDifficulty.medium,
            estimatedTime: '45 minutes',
            materials: ['Multiple bottles', 'Rope', 'Soil', 'Plants'],
            instructions: [
              'Clean all bottles thoroughly',
              'Cut planting holes in each bottle',
              'Create drainage holes at the bottom',
              'Thread rope through bottles for hanging',
              'Fill with soil and plant seeds',
            ],
          ),
        ],
        upcycleCount: 1250,
      ),
      WasteCategoryModel(
        id: 'cardboards',
        name: 'Cardboards',
        imagePath: 'assets/images/cardboard.png',
        description: 'Cardboard boxes and packaging materials',
        projects: [],
        upcycleCount: 890,
      ),
      WasteCategoryModel(
        id: 'pipes',
        name: 'Pipes',
        imagePath: 'assets/images/pipe.png',
        description: 'PVC and metal pipes for creative projects',
        projects: [],
        upcycleCount: 567,
      ),
      WasteCategoryModel(
        id: 'woods',
        name: 'Woods',
        imagePath: 'assets/images/wood.png',
        description: 'Wooden pallets and scrap wood',
        projects: [],
        upcycleCount: 743,
      ),
    ];
  }
}

class UpcyclingProject {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final ProjectDifficulty difficulty;
  final String estimatedTime;
  final List<String> materials;
  final List<String> instructions;

  UpcyclingProject({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.difficulty,
    required this.estimatedTime,
    required this.materials,
    required this.instructions,
  });

  factory UpcyclingProject.fromMap(Map<String, dynamic> map) {
    return UpcyclingProject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      difficulty: ProjectDifficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => ProjectDifficulty.easy,
      ),
      estimatedTime: map['estimatedTime'] ?? '',
      materials: List<String>.from(map['materials'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'difficulty': difficulty.name,
      'estimatedTime': estimatedTime,
      'materials': materials,
      'instructions': instructions,
    };
  }
}

enum ProjectDifficulty {
  easy,
  medium,
  hard;

  String get displayName {
    switch (this) {
      case ProjectDifficulty.easy:
        return 'Easy';
      case ProjectDifficulty.medium:
        return 'Medium';
      case ProjectDifficulty.hard:
        return 'Hard';
    }
  }

  String get description {
    switch (this) {
      case ProjectDifficulty.easy:
        return 'Perfect for beginners';
      case ProjectDifficulty.medium:
        return 'Some experience required';
      case ProjectDifficulty.hard:
        return 'Advanced skills needed';
    }
  }
}
