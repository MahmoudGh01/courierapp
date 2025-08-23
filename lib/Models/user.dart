import 'dart:convert';

class User {
  int idUser;
  String email;
  String name;
  String password;
  String? phoneNumber;
  String? image;
  DateTime? emailVerified;
  bool isActive;
  String? googleId;
  String? facebookId;
  String role;
  bool? isCompany;
  String? companyName;
  String? companyRegistrationNumber;
  String token;
  String refresh;

  User({
    required this.idUser,
    required this.email,
    required this.name,
    required this.password,
    required this.isActive,
    required this.role,
    required this.token,
    required this.refresh,
    this.phoneNumber,
    this.image,
    this.emailVerified,
    this.googleId,
    this.facebookId,
    this.isCompany,
    this.companyName,
    this.companyRegistrationNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phoneNumber'],
      image: json['image'],
      emailVerified: json['emailVerified'] != null
          ? DateTime.tryParse(json['emailVerified'])
          : null,
      isActive: json['isActive'] ?? true,
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      role: json['role'] ?? 'User',
      isCompany: json['isCompany'],
      companyName: json['companyName'],
      companyRegistrationNumber: json['companyRegistrationNumber'],
      token: json['token'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }
  factory User.empty() => User(
    idUser: 0,
    name: '',
    email: '',
    password: '',
    isActive: true,
    role: 'User',
    token: '',
    refresh: '',
    phoneNumber: '',
    image: '',
    emailVerified: null,
    googleId: '',
    facebookId: '',
    isCompany: false,
    companyName: '',
    companyRegistrationNumber: '',
  );
  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'email': email,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'image': image,
      'emailVerified': emailVerified?.toIso8601String(),
      'isActive': isActive,
      'googleId': googleId,
      'facebookId': facebookId,
      'role': role,
      'isCompany': isCompany,
      'companyName': companyName,
      'companyRegistrationNumber': companyRegistrationNumber,
      'token': token,
      'refresh': refresh,
    };
  }

  String toJson() => json.encode(toMap());
}
