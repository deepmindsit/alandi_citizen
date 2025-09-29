class Urls {
  Urls._();

  static const String _baseURL = "https://myalandinp.com/api/v1";
  // static const String _baseURL = "https://alandi.deepmindsit.com/api/v1";
  // static const String _baseURL = "http://192.168.29.102/myalandi_v1/api/v1";
  static String sendOtp = "$_baseURL/send-otp";
  static String register = "$_baseURL/register";
  static String verifyOtp = "$_baseURL/verify-otp";
  static String updateProfile = "$_baseURL/update";
  static String deleteAccount = "$_baseURL/delete-account";
  static String aboutUS = "$_baseURL/get-about-us";
  static String newComplaint = "$_baseURL/complaint";
  static String getComplaint = "$_baseURL/get-complaint";
  static String getComplaintDetails = "$_baseURL/get-complaint-details";
  static String getNotification = "$_baseURL/get-notification";
  static String readNotification = "$_baseURL/read-notification";
  static String getDepartment = "$_baseURL/get-department";
  static String getSlider = "$_baseURL/get-slider";
  static String getWard = "$_baseURL/get-ward";
  static String getLinks = "$_baseURL/get-link";
  static String updateFirebaseToken = "$_baseURL/update-firebase-token";
  static String legalPage = "$_baseURL/get-legal-page";
}
