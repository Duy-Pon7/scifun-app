import 'package:thilop10_3004/common/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  SettingsModel(
      {required super.id,
      required super.settingKey,
      required super.settingName,
      required super.plainValue,
      required super.desc,
      required super.typeInput,
      required super.typeData,
      required super.group,
      required super.createdAt,
      required super.updatedAt});
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json["id"],
      settingKey: json["setting_key"],
      settingName: json["setting_name"],
      plainValue: json["plain_value"],
      desc: json["desc"],
      typeInput: json["type_input"],
      typeData: json["type_data"],
      group: json["group"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}
