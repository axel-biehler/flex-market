/// Enum for the genders
enum Gender {
  /// Men
  men,

  /// Women
  women,

  /// Both genders
  unisex,
}

/// Returns a [Gender] enum value corresponding to the given string
Gender? stringToGender(String? genderString) {
  if (genderString == null) {
    return null;
  }
  return Gender.values.firstWhere(
    (Gender e) => e.name == genderString.toLowerCase(),
    orElse: () => throw ArgumentError('Invalid gender string: $genderString'),
  );
}

/// Enum used to provide the search page gender [ToggleButton] values
enum SearchPageGender {
  /// Both genders
  all,

  /// Men
  men,

  /// WOMEN
  women,
}

/// Enum used to specify an item size
enum ItemSize {
  /// XS
  xs,

  /// S
  s,

  /// M
  m,

  /// L
  l,

  /// XL
  xl,

  /// XXL
  xxl
}

/// Returns a [Size] enum value corresponding to the given string
ItemSize? stringToSize(String? sizeString) {
  if (sizeString == null) {
    return null;
  }
  return ItemSize.values.firstWhere(
    (ItemSize e) => e.name == sizeString.toLowerCase(),
    orElse: () => throw ArgumentError('Invalid size string: $sizeString'),
  );
}

/// Enum that contains the available categories
enum Category {
  /// Tops
  tops,

  /// Bottoms
  bottoms,

  /// Dresses
  dresses,

  /// Outerwear
  outerwear,

  /// Underwear
  underwear,

  /// Footwear
  footwear,

  /// Accessories
  accessories,

  /// Athletic
  athletic,

  /// Sleepwear
  sleepwear,

  /// Swimwear
  swimwear
}

/// Returns a [Category] enum value corresponding to the given string
Category? stringToCategory(String? catString) {
  if (catString == null) {
    return null;
  }
  return Category.values.firstWhere(
    (Category e) => e.name == catString.toLowerCase(),
    orElse: () => throw ArgumentError('Invalid category string: $catString'),
  );
}
