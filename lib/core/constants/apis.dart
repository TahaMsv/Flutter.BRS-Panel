class Apis {
  Apis._();

  // static const baseUrl = 'https://brs-api.abomis.com/default';
  static const String baseUrl = "";
  static const String mainUrl = 'https://brs-api.abomis.com/default';

  // static const String configClassBaseUrl = "https://brsdev-api.abomis.com/brs";
  static const String configClassBaseUrl = "https://brsdev-api.abomis.com/jsn";
  static const String serverSelect = "https://brs-api.abomis.com/default";
  static const String logoUrl = "https://imagedcs.fdcs.ir/api/airlineimage/";
  static const String imageServiceToken = "0F58FF9A-C05B-4FDD-A6A5-5E8D1A102C75";
  static const String uploadProfileImage = "https://imagedcstest.abomis.com/api/profile";

  static String getProfileImage(String username) =>
      "https://imagedcstest.abomis.com/api/imageproject/BRS/ProfilePhoto/$username";
}
