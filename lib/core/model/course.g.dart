// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      imgUrl: json['imgUrl'] as String,
      introVideoUrl: json['introVideoUrl'] as String,
      price: (json['price'] as num).toDouble(),
      outline: json['outline'] as String,
      units: (json['units'] as List<dynamic>)
          .map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CourseImplToJson(_$CourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'introVideoUrl': instance.introVideoUrl,
      'price': instance.price,
      'outline': instance.outline,
      'units': instance.units,
    };
