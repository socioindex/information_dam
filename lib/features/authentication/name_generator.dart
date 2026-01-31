import 'dart:math';

class NameGenerator {
  static List<String> get _adjectives {
    return [
      "Absolute",
      "Belligerent",
      "Conspicuous",
      "Dastardly",
      "Elaborate",
      "Flagrant",
      "Ginormous",
      "Holistic",
      "Indignant",
      "Juxtaposed",
      "Knarled",
      "Lopsided",
      "Mega",
      "Nuanced",
      "Ordinary",
      "Punctual",
      "Quintessential",
      "Rowdy",
      "Sensual",
      "Titular",
      "Unnecessary",
      "Vacated",
      "Wayword",
      "Xenial",
      "Yielding",
      "Zombified",
    ];
  }

  static List<String> get _nouns {
    return [
      "Antagonist",
      "Butler",
      "Cadavre",
      "Dumbwaiter",
      "Entropy",
      "Firefighter",
      "Grasshopper",
      "Hubbub",
      "Isotope",
      "Janitor",
      "Kitten",
      "Laboratory",
      "Monkeybusiness",
      "Nimrod",
      "Octopus",
      "Plant",
      "Quanity",
      "Road",
      "Sarcasm",
      "Torque",
      "Underdog",
      "Variance",
      "Workstation",
      "Xylophone",
      "Yak",
      "Zenith",
    ];
  }

  static String randomWord(List<String> words) {
    return words[Random().nextInt(words.length)];
  }

  static String get name {
    final newName = randomWord(_adjectives) + randomWord(_nouns);
    return newName;
  }
}
