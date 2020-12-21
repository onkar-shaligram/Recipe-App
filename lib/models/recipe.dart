class Recipe {
  String label;
  String source;
  String url;
  String imgUrl;

  Recipe({this.label, this.source, this.url, this.imgUrl});

  factory Recipe.fromMap(Map<String, dynamic> parsedJson) {
    return Recipe(
      imgUrl: parsedJson["image"],
      label: parsedJson["label"],
      source: parsedJson['source'],
      url: parsedJson['url'],
      );
  }
}