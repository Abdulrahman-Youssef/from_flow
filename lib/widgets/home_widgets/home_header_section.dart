import 'package:flutter/material.dart';
import 'package:form_flow/screens/home/home_controller.dart';
import 'package:get/get.dart';

class HomeHeaderSection extends StatelessWidget {
  final String userName;
  final VoidCallback onAddNewDelivery;
  final int totalDeliveries;
  final VoidCallback onLogout;
  final VoidCallback onSettingsTap;
  final VoidCallback onUserTap;

  const HomeHeaderSection({
    super.key,
    required this.userName,
    required this.onAddNewDelivery,
    required this.onLogout,
    required this.onSettingsTap,
    required this.onUserTap,
    required this.totalDeliveries,
  });

  @override
  Widget build(BuildContext context) {
    // Find the controllers if you need it here
    final HomeController controller = Get.find();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 8, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username has been moved from here
                        Text(
                          'Supply Chain Management',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'إدارة سلسلة التوريد',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action buttons row
                  Row(
                    children: [
                      // Tappable User Profile section with name
                      InkWell(
                        onTap: onUserTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.account_circle,
                                  color: Colors.white, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings,
                            color: Colors.white, size: 28),
                        onPressed: onSettingsTap,
                        tooltip: 'Settings',
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: Colors.white, size: 28),
                        onPressed: onLogout,
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Stats and Add Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                  ()=> _buildStatCard(
                      'Total Deliveries',
                      'إجمالي التوريدات',
                      controller.deliveries.length.toString(),
                      Icons.local_shipping,
                      const Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: onAddNewDelivery,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('New Delivery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper widget remains the same
  Widget _buildStatCard(String title, String titleArabic, String value,
      IconData icon, Color backgroundColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(255, 255, 255, 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              titleArabic,
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromRGBO(255, 255, 255, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
