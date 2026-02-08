class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
  });

  static const english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flagEmoji: '🇺🇸',
  );

  static const spanish = Language(
    code: 'es',
    name: 'Spanish',
    nativeName: 'Español',
    flagEmoji: '🇪🇸',
  );

  static const supportedLanguages = [
    english,
    spanish,
  ];

  static Language fromCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => english,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
