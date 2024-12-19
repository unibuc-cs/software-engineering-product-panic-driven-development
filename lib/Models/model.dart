abstract class Model {
  Map<String, dynamic> toJson();
  factory Model.from(Map<String, dynamic> json);
}
