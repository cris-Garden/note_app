
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/local lib/local/Strings.dart
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/local --no-use-deferred-loading lib/local/Strings.dart lib/local/intl_messages.arb lib/local/intl_*.arb


https://qiita.com/jiro-aqua/items/fd9896682ca09018fdd3