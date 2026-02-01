import 'dart:math';

class NameGenerator {
  static List<String> get _adjectives {
    return [
      "Absolute",
      "Belligerent",
      "Conspicuous",
      "Dastardly",
      "Elaborate",
      "Forgetful",
      "Ginormous",
      "Holistic",
      "Indignant",
      "Jaded",
      "Knarled",
      "Lopsided",
      "Mega",
      "Nuanced",
      "Ordinary",
      "Punctual",
      "Quintessential",
      "Rowdy",
      "Serpentine",
      "Titular",
      "Unnecessary",
      "Vacated",
      "Wayword",
      "Xenial",
      "Yielding",
      "Zombified",
      "Angry",
      "Bilingual",
      "Cantankerous",
      "Dangerous",


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
      "Astronaut",
      "Bump",
      "Crutch",
      "Doorbell",
      "Egg",
      "Flower",
      ""

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
