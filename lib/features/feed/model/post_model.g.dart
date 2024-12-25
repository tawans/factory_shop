// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userImage: json['userImage'] as String,
      imageUrl: json['imageUrl'] as String,
      caption: json['caption'] as String,
      likes: (json['likes'] as num).toInt(),
      comments:
          (json['comments'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'userImage': instance.userImage,
      'imageUrl': instance.imageUrl,
      'caption': instance.caption,
      'likes': instance.likes,
      'comments': instance.comments,
      'createdAt': instance.createdAt.toIso8601String(),
    };
