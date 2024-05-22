class AppUrl {
// devUrl ;
  // static var productionUrl = 'https://apidev.lootfat.com/v1';
  //productionUrl
  static var productionUrl = 'https://api.lootfat.com/v1';

  static var register = '$productionUrl/auth/register';
  static var login = '$productionUrl/auth/login';
  static var verifyOtp = '$productionUrl/auth/verify-otp';
  static var forgotPassword = '$productionUrl/auth/send-otp';
  static var changePassword = '$productionUrl/user/change-password';
  static var resetPassword = '$productionUrl/auth/reset-password';
  static var userExitORNot = '$productionUrl/auth/exists-user';
  static var updateShop = '$productionUrl/shop/update';
  static var shopQuestions = '$productionUrl/shop/registration-question';
  static var createBanner = '$productionUrl/shop/sponsored-banner/create';
  static var getBanners = '$productionUrl/shop/sponsored-banner/list?page=1&limit=10';
  static var deleteBanner = '$productionUrl/shop/sponsored-banner/delete';
  static var updateBanner = '$productionUrl/shop/sponsored-banner/update';
  static var updateBannerStatus = '$productionUrl/shop/sponsored-banner/update-status';
  static var notification = '$productionUrl/notification';
  static var offer = '$productionUrl/shop/offer';
  static var offerStatus = '$productionUrl/shop/offer/status';
  static var shopReview = '$productionUrl/shop/review';
  static var analytics = '$productionUrl/shop/dashboard';
}
