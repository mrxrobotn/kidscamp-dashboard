class Parent {
  final String phone;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool canAccess;
  late final List<String> kids;

  Parent({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.canAccess,
    required this.kids,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      canAccess: json['canAccess'],
      kids: (json['kids'] as List<dynamic>?)
          ?.map((kid) => kid.toString())
          .toList() ?? [],
    );
  }
}