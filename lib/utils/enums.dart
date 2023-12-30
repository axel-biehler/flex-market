/// Enum for the genders
enum ItemGender {
  /// Men
  men,

  /// Women
  women,

  /// Both genders
  unisex,
}

/// Returns a [ItemGender] enum value corresponding to the given string
ItemGender? stringToGender(String? genderString) {
  if (genderString == null) {
    return null;
  }
  return ItemGender.values.firstWhere(
    (ItemGender e) => e.name == genderString.toLowerCase(),
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

/// Returns a string corresponding to the given [size]
String sizeToString(ItemSize size) {
  return size.name.toUpperCase();
}

/// Enum that contains the available categories
enum ItemCategory {
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

/// Returns a [ItemCategory] enum value corresponding to the given string
ItemCategory? stringToItemCategory(String? catString) {
  if (catString == null) {
    return null;
  }
  return ItemCategory.values.firstWhere(
    (ItemCategory e) => e.name == catString.toLowerCase(),
    orElse: () => throw ArgumentError('Invalid category string: $catString'),
  );
}
