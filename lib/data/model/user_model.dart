class UserModel {
  String email;
  String bio;
  String username;
  String profile;
  List following;
  List followers;
  UserModel(
    this.bio,
    this.email,
    this.followers,
    this.following,
    this.profile,
    this.username,
  );
}
