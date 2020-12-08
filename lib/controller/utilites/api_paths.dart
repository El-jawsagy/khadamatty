class ApiPaths {
  static String mainDirection = "https://khadamatty.com/api";

  static String signUp = mainDirection + "/signup";
  static String login = mainDirection + "/login";
  static String getUser = mainDirection + "/user";

  static String updateProfile = mainDirection + "/updateprofile";

  static String categories() => mainDirection + "/categories";

  static String storeSubCategory(
    categoryId,
  ) =>
      mainDirection + "/categories/$categoryId";

  static String storeSubCategoryProduct(categoryId, userId) =>
      mainDirection + "/category/listings/$categoryId?user_id=$userId";
  static String allCategory = mainDirection + "/categories";

  static String getTagsAndCategory = mainDirection + "/tags";

  static String getSpecificId(id) => mainDirection + "/tags?categroy_id=$id";

  static String getAllCountries = mainDirection + "/countries";

  static String singleAnnouncement(productId) =>
      mainDirection + "/singlelisting?listing_id=$productId";
  static String uploadAnnouncement = mainDirection + "/post-listing";
  static String updataAnnouncement = mainDirection + "/update-listing";
  static String removeListing = mainDirection + "/remove-listing";

  static String favoriteUser(id) =>
      mainDirection + "/user-favourite?user_id=$id";

  static String addFavoriteItem(userId, listingId) =>
      mainDirection + "/add-to-fav?user_id=$userId&listing_id=$listingId";
  static String removeFavoriteItem = mainDirection + "/remove-favourite";

  static String notificationUser(id) =>
      mainDirection + "/notifications?user_id=$id";

  static String commission = mainDirection + "/commission";
  static String allBanks = mainDirection + "/banks";


  static String aboutUs(lang) => mainDirection + "/about_us?lang=$lang";
  static String termsOfUse(lang) =>
      mainDirection + "/usage_agreement?lang=$lang";
  static String discount(lang) =>
      mainDirection + "/website_commission?lang=$lang";
  static String blackList(lang) =>
      mainDirection + "/blacklist_handling?lang=$lang";
  static String contactUs = mainDirection + "/contact_us";

  static String searchAdds(
    string,
  ) =>
      mainDirection + "/searchlisting?&search=$string";

  static String addStoreComment = mainDirection + "/add-comment";
}
