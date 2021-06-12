class Exercise {
  String id;
  String name;
  String sets;

  Exercise({
    this.id, this.sets, this.name
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => new Exercise(
    id: json['id'],
    name: json['name'],
    sets: json['sets']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sets": sets
  };
}
