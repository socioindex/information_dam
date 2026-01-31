import 'dart:math';

class NameGenerator {
  static List<String> get _adjectives {
    return ["Absolute", "Belligerent", "Conspiring", "Dastardly", "Excellent"];
  }

  static List<String> get _nouns {
    return ["Antagonist", "Butler","Cadavre", "Dumbwaiter", "Entropy"];
  }

  static String randomWord(List<String> words) {
    return words[Random().nextInt(words.length)];
  }

  static String get name {
    final newName = randomWord(_adjectives) + randomWord(_nouns);
    return newName;
  }
}
