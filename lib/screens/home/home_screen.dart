import 'package:flutter/material.dart';
import 'package:form_flow/app_state.dart';
import 'package:form_flow/screens/home/home_controller.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/widgets/home_widgets/home_build_delivery_card.dart';
import 'package:form_flow/widgets/home_widgets/home_build_empty_state.dart';
import 'package:form_flow/widgets/home_widgets/home_header_section.dart';
import 'package:form_flow/widgets/home_widgets/home_search_section.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  // will be moved to controllers until that happened it will stay here
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
          HomeHeaderSection(
            onAddNewDelivery: controller.onAddNewDelivery,
            totalDeliveries: controller.deliveries.length,
            onLogout: Get.find<AppController>().logout,
            onSettingsTap: () {},
            onUserTap: () {},
            userName: 'ahmed',
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
                            onDeleteTap: controller.removeDelivery,
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
}
