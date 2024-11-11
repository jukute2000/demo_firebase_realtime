class Item {
  final String id;
  final String title;
  final String description;
  final String urlImage;
  final int price;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.urlImage,
  });

  factory Item.FromToJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        urlImage: json["urlImage"],
      );

  toJson() => {
        "title": title,
        "description": description,
        "price": price,
        "urlImage": urlImage,
      };
}
