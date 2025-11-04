import 'package:form_flow/models/shipment_model.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/trip_data.dart';

List <SupplyDeliveryData> homeScreenList  = [
  SupplyDeliveryData(
      id: 1,
      name: "name",
      date: DateTime(2025, 9, 23),
      trips: [
        TripData(
          id: 1,
            vehicleCode: "1019",
            storages: [],
            procurementSpecialist: "procurementSpecialist",
            fleetSupervisor: "fa",
            suppliers: [
              SupplierData(
                id: 1,
                supplierName: "GDA Logistics",
                // Arrived yesterday in the morning
                actualArriveDate:
                DateTime(2025, 10, 9, 10, 30),
                // Departed yesterday in the afternoon
                actualDepartureDate:
                DateTime(2025, 10, 9, 14, 0),
                planArriveDate: DateTime(2025, 10, 9, 10, 0),
              ),
              SupplierData(
                id: 2,
                supplierName: "Cairo Couriers",
                // Arrived today in the morning
                actualArriveDate:
                DateTime(2025, 10, 10, 9, 5),
                // Departed today just after noon
                actualDepartureDate:
                DateTime(2025, 10, 10, 12, 45),
                planArriveDate: DateTime(2025, 10, 10, 9, 15),
              ),
              SupplierData(
                id: 3,
                supplierName: "Nile Valley Transport",
                // Arrived this afternoon
                actualArriveDate:
                DateTime(2025, 10, 10, 15, 20),
                // Departed this evening
                actualDepartureDate:
                DateTime(2025, 10, 10, 18, 5),
                planArriveDate: DateTime(2025, 10, 10, 16, 0),
              ),
              SupplierData(
                id: 4,
                supplierName: "Red Sea Freights",
                // Arrived two days ago
                actualArriveDate:
                DateTime(2025, 10, 8, 11, 0),
                // Departed late the same night
                actualDepartureDate:
                DateTime(2025, 10, 8, 23, 30),
                planArriveDate: DateTime(2025, 10, 8, 11, 30),
              ),
            ])
      ], createdBy: '1'),
  SupplyDeliveryData(
      id: 2,
      name: "ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
      date: DateTime(2025, 9, 24),
      trips: [
        TripData(
          id: 1,
            vehicleCode: "1019",
            storages: [],
            procurementSpecialist: "procurementSpecialist",
            fleetSupervisor: "fa",
            suppliers: [
              SupplierData(
                id: 1,
                supplierName: "GDA Logistics",
                // Arrived yesterday in the morning
                actualArriveDate:
                DateTime(2025, 10, 9, 10, 30),
                // Departed yesterday in the afternoon
                actualDepartureDate:
                DateTime(2025, 10, 9, 14, 0),
                planArriveDate: DateTime(2025, 10, 9, 10, 0),
              ),
              SupplierData(
                id: 2,
                supplierName: "Cairo Couriers",
                // Arrived today in the morning
                actualArriveDate:
                DateTime(2025, 10, 10, 9, 5),
                // Departed today just after noon
                actualDepartureDate:
                DateTime(2025, 10, 10, 12, 45),
                planArriveDate: DateTime(2025, 10, 10, 9, 15),
              ),
              SupplierData(
                id: 3,
                supplierName: "Nile Valley Transport",
                // Arrived this afternoon
                actualArriveDate:
                DateTime(2025, 10, 10, 15, 20),
                // Departed this evening
                actualDepartureDate:
                DateTime(2025, 10, 10, 18, 5),
                planArriveDate: DateTime(2025, 10, 10, 16, 0),
              ),
              SupplierData(
                id: 4,
                supplierName: "Red Sea Freights",
                // Arrived two days ago
                actualArriveDate:
                DateTime(2025, 10, 8, 11, 0),
                // Departed late the same night
                actualDepartureDate:
                DateTime(2025, 10, 8, 23, 30),
                planArriveDate: DateTime(2025, 10, 8, 11, 30),
              ),
            ])
      ], createdBy: '1'),
  SupplyDeliveryData(
      id: 3,
      name: "name",
      date: DateTime(2025, 9, 23),
      trips: [
        TripData(
          id: 1,
            vehicleCode: "1019",
            storages: [],
            procurementSpecialist: "procurementSpecialist",
            fleetSupervisor: "fa",
            suppliers: [
              SupplierData(
                id: 1,
                supplierName: "GDA Logistics",
                // Arrived yesterday in the morning
                actualArriveDate:
                DateTime(2025, 10, 9, 10, 30),
                // Departed yesterday in the afternoon
                actualDepartureDate:
                DateTime(2025, 10, 9, 14, 0),
                planArriveDate: DateTime(2025, 10, 9, 10, 0),
              ),
              SupplierData(
                id: 2,
                supplierName: "Cairo Couriers",
                // Arrived today in the morning
                actualArriveDate:
                DateTime(2025, 10, 10, 9, 5),
                // Departed today just after noon
                actualDepartureDate:
                DateTime(2025, 10, 10, 12, 45),
                planArriveDate: DateTime(2025, 10, 10, 9, 15),
              ),
              SupplierData(
                id: 3,
                supplierName: "Nile Valley Transport",
                // Arrived this afternoon
                actualArriveDate:
                DateTime(2025, 10, 10, 15, 20),
                // Departed this evening
                actualDepartureDate:
                DateTime(2025, 10, 10, 18, 5),
                planArriveDate: DateTime(2025, 10, 10, 16, 0),
              ),
              SupplierData(
                id: 4,
                supplierName: "Red Sea Freights",
                // Arrived two days ago
                actualArriveDate:
                DateTime(2025, 10, 8, 11, 0),
                // Departed late the same night
                actualDepartureDate:
                DateTime(2025, 10, 8, 23, 30),
                planArriveDate: DateTime(2025, 10, 8, 11, 30),
              ),
            ])
      ], createdBy: '1'),
  SupplyDeliveryData(
      id: 4,
      name: "name",
      date: DateTime(2025, 9, 23),
      trips: [
        TripData(
          id: 1,
            vehicleCode: "1019",
            storages: [],
            procurementSpecialist: "procurementSpecialist",
            fleetSupervisor: "fa",
            suppliers: [
              SupplierData(
                id: 1,
                supplierName: "GDA Logistics",
                // Arrived yesterday in the morning
                actualArriveDate:
                DateTime(2025, 10, 9, 10, 30),
                // Departed yesterday in the afternoon
                actualDepartureDate:
                DateTime(2025, 10, 9, 14, 0),
                planArriveDate: DateTime(2025, 10, 9, 10, 0),
              ),
              SupplierData(
                id: 2,
                supplierName: "Cairo Couriers",
                // Arrived today in the morning
                actualArriveDate:
                DateTime(2025, 10, 10, 9, 5),
                // Departed today just after noon
                actualDepartureDate:
                DateTime(2025, 10, 10, 12, 45),
                planArriveDate: DateTime(2025, 10, 10, 9, 15),
              ),
              SupplierData(
                id: 3,
                supplierName: "Nile Valley Transport",
                // Arrived this afternoon
                actualArriveDate:
                DateTime(2025, 10, 10, 15, 20),
                // Departed this evening
                actualDepartureDate:
                DateTime(2025, 10, 10, 18, 5),
                planArriveDate: DateTime(2025, 10, 10, 16, 0),
              ),
              SupplierData(
                id: 4,
                supplierName: "Red Sea Freights",
                // Arrived two days ago
                actualArriveDate:
                DateTime(2025, 10, 8, 11, 0),
                // Departed late the same night
                actualDepartureDate:
                DateTime(2025, 10, 8, 23, 30),
                planArriveDate: DateTime(2025, 10, 8, 11, 30),
              ),
            ])
      ], createdBy: '1'),
  SupplyDeliveryData(
      id: 5,
      name: "name",
      date: DateTime(2025, 9, 23),
      trips: [
        TripData(
          id: 1,
            vehicleCode: "1019",
            storages: [],
            procurementSpecialist: "procurementSpecialist",
            fleetSupervisor: "fa",
            suppliers: [
              SupplierData(
                id: 1,
                supplierName: "GDA Logistics",
                // Arrived yesterday in the morning
                actualArriveDate:
                DateTime(2025, 10, 9, 10, 30),
                // Departed yesterday in the afternoon
                actualDepartureDate:
                DateTime(2025, 10, 9, 14, 0),
                planArriveDate: DateTime(2025, 10, 9, 10, 0),
              ),
              SupplierData(
                id: 2,
                supplierName: "Cairo Couriers",
                // Arrived today in the morning
                actualArriveDate:
                DateTime(2025, 10, 10, 9, 5),
                // Departed today just after noon
                actualDepartureDate:
                DateTime(2025, 10, 10, 12, 45),
                planArriveDate: DateTime(2025, 10, 10, 9, 15),
              ),
              SupplierData(
                id: 3,
                supplierName: "Nile Valley Transport",
                // Arrived this afternoon
                actualArriveDate:
                DateTime(2025, 10, 10, 15, 20),
                // Departed this evening
                actualDepartureDate:
                DateTime(2025, 10, 10, 18, 5),
                planArriveDate: DateTime(2025, 10, 10, 16, 0),
              ),
              SupplierData(
                id: 4,
                supplierName: "Red Sea Freights",
                // Arrived two days ago
                actualArriveDate:
                DateTime(2025, 10, 8, 11, 0),
                // Departed late the same night
                actualDepartureDate:
                DateTime(2025, 10, 8, 23, 30),
                planArriveDate: DateTime(2025, 10, 8, 11, 30),
              ),
            ])
      ], createdBy: 'Ahmed'),

];