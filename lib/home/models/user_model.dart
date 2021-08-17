import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  UserModel({
    required this.latitude,
    required this.longitude,
  }) : date = DateTime.now().millisecondsSinceEpoch.toString();

  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String date;

  @override
  String toString() {
    return 'latitude: $latitude; longitude: $longitude, date: $date';
  }
}
