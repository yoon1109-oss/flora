class FlowerImage {
  final int? id;
  final int imageNumber;
  final String imagePath;

  const FlowerImage({
    this.id,
    required this.imageNumber,
    required this.imagePath,
  });

  factory FlowerImage.fromMap(Map<String, dynamic> map) {
    return FlowerImage(
      id: map['id'] as int?,
      imageNumber: map['image_number'] as int,
      imagePath: map['image_path'] as String,
    );
  }
}

class Flower {
  final int? id;
  final String name;
  final String floriography;
  final String feature;
  final String review;
  final List<FlowerImage> images;
  final List<int> seasons;

  const Flower({
    this.id,
    required this.name,
    required this.floriography,
    required this.feature,
    required this.review,
    this.images = const [],
    this.seasons = const [],
  });

  String get heroImage =>
      images.isNotEmpty
          ? images.firstWhere(
            (img) => img.imageNumber == 1,
            orElse: () => images.first,
          ).imagePath
          : 'assets/images/peony_hero.jpg';

  List<FlowerImage> get thumbnails =>
      List<FlowerImage>.from(images)
        ..sort((a, b) => a.imageNumber.compareTo(b.imageNumber));

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'floriography': floriography,
      'feature': feature,
      'review': review,
    };
  }

  factory Flower.fromMap(
    Map<String, dynamic> map, {
    List<int>? seasons,
    List<FlowerImage>? images,
  }) {
    return Flower(
      id: map['id'] as int?,
      name: map['name'] as String,
      floriography: map['floriography'] as String,
      feature: map['feature'] as String,
      review: map['review'] as String,
      images: images ?? [],
      seasons: seasons ?? [],
    );
  }
}
