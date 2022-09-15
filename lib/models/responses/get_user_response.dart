class GetUserResponse {
  final bool isSuccessful;
  final String message;
  final dynamic user;
  final bool? isOwner;

  GetUserResponse({required this.isSuccessful, required this.message, this.user, required this.isOwner});
}
