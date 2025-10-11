import 'package:flutter/material.dart';
import 'package:form_flow/controller/home_controller.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:form_flow/widgets/home_widgets/home_build_delivery_card.dart';
import 'package:form_flow/widgets/home_widgets/home_build_empty_state.dart';
import 'package:form_flow/widgets/home_widgets/home_header_section.dart';
import 'package:form_flow/widgets/home_widgets/home_search_section.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  // will be moved to controller until that happened it will stay here
  final Function(SupplyDeliveryData) onDeliveryTap;
  final VoidCallback onAddNewDelivery;

  const HomeScreen({
    super.key,
    required this.onDeliveryTap,
    required this.onAddNewDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header Section
          homeHeaderSection(
            onAddNewDelivery: controller.onAddNewDelivery,
            totalDeliveries: controller.deliveries.length,
          ),

          // Search and Filter Section
          SearchAndSortBar(
            onSearchChanged: controller.updateSearchQuery,
            onSortChanged: controller.updateSortBy,
            currentSortBy: controller.sortBy.value,
          ),
          // Deliveries Grid
          Expanded(
            child: Obx(() => controller.filteredDeliveries.isEmpty
                ? buildEmptyState(onAddNewDelivery: controller.onAddNewDelivery)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: controller.filteredDeliveries.length,
                        itemBuilder: (context, index) {
                          final delivery = controller.filteredDeliveries[index];
                          return buildDeliveryCard(
                            delivery: delivery,
                            onDeliveryTap: controller.onEditeDelivery,
                          );
                        },
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }

// Widget _buildStatCard(String title, String titleArabic, String value,
//     IconData icon, Color backgroundColor) {
//   return Expanded(
//     child: Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.white, size: 24),
//               Spacer(),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.white.withValues(alpha: 0.8),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             titleArabic,
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.white.withValues(alpha: 0.6),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget buildDeliveryCard(SupplyDeliveryData delivery) {
//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//     child: InkWell(
//       onTap: () => onDeliveryTap(delivery),
//       borderRadius: BorderRadius.circular(16),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header with name and date
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     delivery.name,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E3A8A),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF1E3A8A).withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     DateFormat('dd/MM').format(delivery.date),
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1E3A8A),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 8),
//
//             Text(
//               DateFormat('EEEE, dd MMMM yyyy').format(delivery.date),
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             SizedBox(height: 12),
//             // Stats Grid
//             Row(
//               children: [
//                 Expanded(
//                   child: buildMiniStat(
//                     delivery.tripsCount.toString(),
//                     'Trips',
//                     'رحلات',
//                     Icons.route,
//                     Colors.blue,
//                   ),
//                 ),
//                 SizedBox(width: 6),
//                 Expanded(
//                   child: buildMiniStat(
//                     delivery.suppliersCount.toString(),
//                     'Suppliers',
//                     'موردين',
//                     Icons.business,
//                     Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 6),
//             Row(
//               children: [
//                 Expanded(
//                   child: buildMiniStat(
//                     delivery.vehiclesCount.toString(),
//                     'Vehicles',
//                     'مركبات',
//                     Icons.local_shipping,
//                     Colors.orange,
//                   ),
//                 ),
//                 SizedBox(width: 6),
//                 Expanded(child: SizedBox()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget buildMiniStat(String value, String label, String labelArabic,
//     IconData icon, Color color) {
//   return Container(
//     padding: EdgeInsets.all(6),
//     decoration: BoxDecoration(
//       color: color.withValues(alpha: 0.1),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: color, size: 14),
//         SizedBox(height: 2),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 8,
//             color: Colors.grey.shade600,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         Text(
//           labelArabic,
//           style: TextStyle(
//             fontSize: 7,
//             color: Colors.grey.shade500,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     ),
//   );
// }

// Widget buildEmptyState() {
//   return Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.local_shipping_outlined,
//           size: 64,
//           color: Colors.grey.shade400,
//         ),
//         SizedBox(height: 16),
//         Text(
//           'No deliveries found',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'Create your first delivery to get started',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade500,
//           ),
//         ),
//         SizedBox(height: 24),
//         ElevatedButton.icon(
//           onPressed: onAddNewDelivery,
//           icon: Icon(Icons.add),
//           label: Text('Create New Delivery'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF1E3A8A),
//             foregroundColor: Colors.white,
//             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
