import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phone;

  AppUser({required this.uid, required this.email, this.name, this.photoUrl, this.phone});

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
