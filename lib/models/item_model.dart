class Item {
  final String id;
  final String title;
  final String idType;
  final String description;
  final String urlImage;
  final String tagImage;
  final int price;
  final int status;
  Item({
    required this.id,
    required this.title,
    required this.idType,
    required this.description,
    required this.price,
    required this.urlImage,
    required this.status,
    required this.tagImage,
  });

  factory Item.FromToJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        idType: json["idType"],
        description: json["description"],
        price: json["price"],
        urlImage: json["urlImage"],
        tagImage: json["tagImage"],
        status: json["status"],
      );

  toJson() => {
        "title": title,
        "idType": idType,
        "description": description,
        "price": price,
        "urlImage": urlImage,
        "tagImage": tagImage,
        "status": status,
      };
}
