class HomeSettings {
  const HomeSettings({
    this.dailyCardioMinutes = 30,
    this.weeklyCardioMinutes = 90,
    this.creatineEnabled = true,
  });

  final int dailyCardioMinutes;
  final int weeklyCardioMinutes;
  final bool creatineEnabled;

  bool get showCardio => dailyCardioMinutes > 0 || weeklyCardioMinutes > 0;

  factory HomeSettings.fromJson(Map<String, dynamic> json) => HomeSettings(
        dailyCardioMinutes: (json['dailyCardio'] as num?)?.toInt() ??
            (json['dailyCardioMinutes'] as num?)?.toInt() ??
            0,
        weeklyCardioMinutes: (json['weeklyCardioMinutes'] as num?)?.toInt() ?? 0,
        creatineEnabled:
            (json['showCreatine'] ?? json['creatineEnabled']) != false,
      );

  Map<String, dynamic> toJson() => {
        'dailyCardioMinutes': dailyCardioMinutes,
        'weeklyCardioMinutes': weeklyCardioMinutes,
        'creatineEnabled': creatineEnabled,
      };

  Map<String, dynamic> toApiJson() => {
        'showCreatine': creatineEnabled,
        'dailyCardio': dailyCardioMinutes,
      };
}
