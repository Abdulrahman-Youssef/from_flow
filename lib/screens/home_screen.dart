import 'package:flutter/material.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:intl/intl.dart';

class SupplyDeliveryData {
  final String id;
  final String name;
  final DateTime date;
  final List<TripData> trips;

  SupplyDeliveryData({
    required this.id,
    required this.name,
    required this.date,
    required this.trips,
  });

  int get tripsCount => trips.length;

  int get suppliersCount => trips
      .expand((trip) => trip.suppliers)
      .length;

  int get vehiclesCount => trips
      .map((trip) => trip.vehicleCode)
      .toSet()
      .length;

// int get storagesCount => trips
//     .expand((trip) => trip.name)
//     .map((storage) => storage.storageName)
//     .toSet()
//     .length;
}

class HomeScreen extends StatefulWidget {
  final List<SupplyDeliveryData> deliveries;
  final Function(SupplyDeliveryData) onDeliveryTap;
  final VoidCallback onAddNewDelivery;

  const HomeScreen({
    super.key,
    required this.deliveries,
    required this.onDeliveryTap,
    required this.onAddNewDelivery,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _sortBy = 'date'; // 'date', 'name', 'trips'

  List<SupplyDeliveryData> get _filteredDeliveries {
    var filtered = widget.deliveries.where((delivery) {
      final matchesSearch = delivery.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          DateFormat('dd/MM/yyyy').format(delivery.date).contains(_searchQuery);
      return matchesSearch;
    }).toList();

    // Sort deliveries
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'trips':
          return b.tripsCount.compareTo(a.tripsCount);
        case 'date':
        default:
          return b.date.compareTo(a.date); // Most recent first
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
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
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supply Chain Management',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'إدارة سلسلة التوريد',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: widget.onAddNewDelivery,
                          icon: Icon(Icons.add, size: 20),
                          label: Text('New Delivery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1E3A8A),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatCard(
                          'Total Deliveries',
                          'إجمالي التوريدات',
                          widget.deliveries.length.toString(),
                          Icons.local_shipping,
                          Colors.white.withValues(alpha: 0.2),
                        ),
                        SizedBox(width: 16),
                        _buildStatCard(
                          'Active Trips',
                          'الرحلات النشطة',
                          widget.deliveries.fold<int>(0, (sum, d) => sum + d.tripsCount).toString(),
                          Icons.route,
                          Colors.white.withValues(alpha: 0.2),
                        ),
                        SizedBox(width: 16),
                        _buildStatCard(
                          'Total Suppliers',
                          'إجمالي الموردين',
                          widget.deliveries.fold<int>(0, (sum, d) => sum + d.suppliersCount).toString(),
                          Icons.business,
                          Colors.white.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search deliveries...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    items: [
                      DropdownMenuItem(value: 'date', child: Text('Date')),
                      DropdownMenuItem(value: 'name', child: Text('Name')),
                      DropdownMenuItem(value: 'trips', child: Text('Trips Count')),
                    ],
                    onChanged: (value) => setState(() => _sortBy = value!),
                  ),
                ),
              ],
            ),
          ),

          // Deliveries Grid
          Expanded(
            child: _filteredDeliveries.isEmpty
                ? _buildEmptyState()
                : Padding(
              padding: EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredDeliveries.length,
                    itemBuilder: (context, index) {
                      final delivery = _filteredDeliveries[index];
                      return _buildDeliveryCard(delivery);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildStatCard(String title, String titleArabic, String value, IconData icon, Color backgroundColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
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
                Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              titleArabic,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(SupplyDeliveryData delivery) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => widget.onDeliveryTap(delivery),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      delivery.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E3A8A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat('dd/MM').format(delivery.date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(delivery.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 16),

              // Stats Grid
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMiniStat(
                        delivery.tripsCount.toString(),
                        'Trips',
                        'رحلات',
                        Icons.route,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildMiniStat(
                        delivery.suppliersCount.toString(),
                        'Suppliers',
                        'موردين',
                        Icons.business,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildMiniStat(
                      delivery.vehiclesCount.toString(),
                      'Vehicles',
                      'مركبات',
                      Icons.local_shipping,
                      Colors.orange,
                    ),
                  ),
                  SizedBox(width: 8),
                  // Expanded(
                  //   child: _buildMiniStat(
                  //     delivery.storagesCount.toString(),
                  //     'Storages',
                  //     'مخازن',
                  //     Icons.warehouse,
                  //     Colors.purple,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, String labelArabic, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            labelArabic,
            style: TextStyle(
              fontSize: 7,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No deliveries found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first delivery to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onAddNewDelivery,
            icon: Icon(Icons.add),
            label: Text('Create New Delivery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}