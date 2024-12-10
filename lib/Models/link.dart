class Link {
  // Data
  int id;
  String name;
  String href;

  Link({this.id = -1, required this.name, required this.href});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Link).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
      "href": href,
    };
  }

  factory Link.from(Map<String, dynamic> json) {
    return Link(
      id: json["id"],
      name: json["name"],
      href: json["href"],
    );
  }
}