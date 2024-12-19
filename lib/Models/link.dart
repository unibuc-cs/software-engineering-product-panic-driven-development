import 'model.dart';

class Link implements Model {
  // Data
  int id;
  String name;
  String href;

  Link({
    this.id = -1,
    required this.name,
    required this.href
  });

  static String get endpoint => 'links';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Link).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'href': href,
    };
  }

  @override
  factory Link.from(Map<String, dynamic> json) {
    return Link(
      id: json['id'],
      name: json['name'],
      href: json['href'],
    );
  }
}