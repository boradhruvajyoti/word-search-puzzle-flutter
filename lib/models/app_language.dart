// Models: AppLanguage — English only metadata
class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  static const List<AppLanguage> languages = [
    AppLanguage(code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸'),
  ];

  static AppLanguage fromCode(String code) {
    return languages.first;
  }
}
