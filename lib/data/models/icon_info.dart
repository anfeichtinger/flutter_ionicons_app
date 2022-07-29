import 'package:hive_flutter/hive_flutter.dart';

part 'icon_info.g.dart';

@HiveType(typeId: 0)
class IconInfo {
  IconInfo({required this.name, required this.value});

  @HiveField(0)
  final String name;

  @HiveField(1)
  final int value;
}
