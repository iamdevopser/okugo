enum CefrLevel {
  a1a2,
  a2b1,
  b1b2,
  b2c1,
  c1c2;
}

extension CefrLevelX on CefrLevel {
  String get label {
    switch (this) {
      case CefrLevel.a1a2:
        return 'A1–A2';
      case CefrLevel.a2b1:
        return 'A2–B1';
      case CefrLevel.b1b2:
        return 'B1–B2';
      case CefrLevel.b2c1:
        return 'B2–C1';
      case CefrLevel.c1c2:
        return 'C1–C2';
    }
  }

  static CefrLevel fromLabel(String label) {
    final normalized = label.replaceAll(' ', '');
    for (final level in CefrLevel.values) {
      if (level.label.replaceAll(' ', '') == normalized) return level;
    }
    return CefrLevel.a1a2;
  }

  String toJson() => name;

  static CefrLevel fromJson(String value) {
    return CefrLevel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CefrLevel.a1a2,
    );
  }
}

