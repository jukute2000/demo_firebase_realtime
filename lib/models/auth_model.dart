class Auth {
  String? _id;
  String gmail;
  String userName;
  String phone;
  String image;

  String? get getId => _id;
  set setId(String id) => _id = id;

  Auth({
    required this.gmail,
    required this.userName,
    required this.phone,
    required this.image,
  });
}
