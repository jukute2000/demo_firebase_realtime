class Address {
  String idAddress;
  String name;
  String phone;
  String address;
  int status;

  Address(
      {required this.idAddress,
      required this.name,
      required this.phone,
      required this.address,
      required this.status});

  factory Address.FormToJson(Map<String, dynamic> json) => Address(
        idAddress: json["idAddress"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        status: json["status"],
      );
}
