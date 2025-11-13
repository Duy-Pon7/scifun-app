class SettingsEntity {
  SettingsEntity({
    this.id,
    this.settingKey,
    this.settingName,
    this.plainValue,
    this.desc,
    this.typeInput,
    this.typeData,
    this.group,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? settingKey;
  final String? settingName;
  final String? plainValue;
  final String? desc;
  final int? typeInput;
  final dynamic typeData;
  final int? group;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
