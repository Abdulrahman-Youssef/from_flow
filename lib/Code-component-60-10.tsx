import 'package:flutter/foundation.dart';
import 'models/supplier_data.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  List<SupplierData> _data = [
    SupplierData(
      id: 1,
      supplierName: "ABC Logistics Co.",
      storageName: "Warehouse A",
      carId: "CAR-001",
      procurementSpecialist: "John Smith",
      supervisorName: "Sarah Johnson",
      actualArriveDate: DateTime(2024, 1, 15, 8, 30),
      actualLeaveDate: DateTime(2024, 1, 18, 14, 45),
    ),
    SupplierData(
      id: 2,
      supplierName: "Global Supply Ltd.",
      storageName: "Storage Facility B",
      carId: "CAR-002",
      procurementSpecialist: "Emily Davis",
      supervisorName: "Michael Brown",
      actualArriveDate: DateTime(2024, 1, 20, 9, 15),
      actualLeaveDate: DateTime(2024, 1, 25, 16, 20),
    ),
    SupplierData(
      id: 3,
      supplierName: "Quick Transport Inc.",
      storageName: "Warehouse C",
      carId: "CAR-003",
      procurementSpecialist: "Robert Wilson",
      supervisorName: "Lisa Anderson",
      actualArriveDate: DateTime(2024, 1, 22, 10, 0),
      actualLeaveDate: DateTime(2024, 1, 24, 13, 30),
    ),
    SupplierData(
      id: 4,
      supplierName: "Reliable Freight",
      storageName: "Storage Unit D",
      carId: "CAR-004",
      procurementSpecialist: "David Martinez",
      supervisorName: "Jennifer Taylor",
      actualArriveDate: DateTime(2024, 1, 25, 7, 45),
      actualLeaveDate: DateTime(2024, 1, 30, 15, 10),
    ),
    SupplierData(
      id: 5,
      supplierName: "Express Delivery Co.",
      storageName: "Warehouse E",
      carId: "CAR-005",
      procurementSpecialist: "Amanda White",
      supervisorName: "Kevin Miller",
      actualArriveDate: DateTime(2024, 1, 28, 11, 20),
      actualLeaveDate: DateTime(2024, 2, 2, 17, 0),
    ),
  ];

  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));

  bool get isLoggedIn => _isLoggedIn;
  List<SupplierData> get data => _data;
  DateTime get selectedDate => _selectedDate;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addRecord(SupplierData record) {
    final newId = _data.isEmpty ? 1 : _data.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    _data.add(record.copyWith(id: newId));
    notifyListeners();
  }

  void updateRecord(SupplierData record) {
    final index = _data.indexWhere((item) => item.id == record.id);
    if (index != -1) {
      _data[index] = record;
      notifyListeners();
    }
  }

  void deleteRecord(int id) {
    _data.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void copyRecord(int id) {
    final record = _data.firstWhere((item) => item.id == id);
    final newId = _data.isEmpty ? 1 : _data.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final copiedRecord = record.copyWith(
      id: newId,
      carId: '${record.carId}-COPY',
    );
    _data.add(copiedRecord);
    notifyListeners();
  }
}