abstract class Model {
  const Model();

  dynamic get id;

  Map<String, dynamic> toJson() {
    throw UnimplementedError('The toJson method was not defined for this type');
  }

  factory Model.from(Map<String, dynamic> json) {
    throw UnimplementedError('The factory method was not defined for this type');
  }
}
