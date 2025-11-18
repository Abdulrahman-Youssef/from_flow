class ServicesRoutes {
  static const String register = "/register";
  static const String login = "/login";
  static const String logout = "/logout";
  static const String user = "/user";
  static const String profilePicture = "/profile-picture";

  static const String deliveryDropData = "/delivery-form-data";

  // Base route
  static const String deliveryBase = "/delivery";

  // GET /delivery
  static String deliveriesSummary = deliveryBase;

  // GET /delivery/{id}
  static String deliveryDetails(int id) => "$deliveryBase/$id";

  // POST /delivery
  static String createDelivery = deliveryBase;

  // PUT /delivery/{id}
  static String updateDelivery(int id) => "$deliveryBase/$id";

  // DELETE /delivery/{id}
  static String deleteDelivery(int id) => "$deliveryBase/$id";
}
