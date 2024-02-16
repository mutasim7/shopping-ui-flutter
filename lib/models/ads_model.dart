class AdsModel {
  final String imageUrl;

  AdsModel({required this.imageUrl});

  factory AdsModel.fromjson(Map<String, dynamic> json) {
    return AdsModel(imageUrl: json['image']);
  }
}
