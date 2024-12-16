class TypeItem {
  final String idType;
  final String nameType;
  final int status;

  TypeItem({
    required this.idType,
    required this.nameType,
    required this.status,
  });

  factory TypeItem.FromJson(Map<String, dynamic> json) => TypeItem(
        idType: json["idType"],
        nameType: json["nameType"],
        status: json["status"],
      );

  toMap() => {idType: nameType};
}
