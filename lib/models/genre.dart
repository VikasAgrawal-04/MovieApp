class Genre {
  Genre(
    this.id,
    this.name,
  );

  final int id;
  final String name;

  Genre.fromJson(Map<String, dynamic> json):
    id = json["id"],
    name = json["name"];
}