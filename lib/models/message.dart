import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageSender { user, ai }

@JsonSerializable()
class Message {
  final String text;
  final MessageSender sender;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isLoading;

  Message({required this.text, required this.sender, this.isLoading = false});

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
