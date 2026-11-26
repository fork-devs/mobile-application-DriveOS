import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/analytics/application/analytics_application.dart';
import 'package:mobile_application_driveos/features/analytics/infrastructure/remote/analytics_api.dart';
import 'package:mobile_application_driveos/features/analytics/infrastructure/repositories/analytics_repository_impl.dart';

class _InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data = {};

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<Map<String, String>> readAll() async => Map<String, String>.from(_data);

  @override
  Future<void> write(String key, String value) async => _data[key] = value;
}

void main() {
  group('Analytics Layers', () {
    test('GetAnalytics parses branch summary and employee summary', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.branchAnalyticsSummary('b-1')) {
          return http.Response(
            jsonEncode({
              'branchId': 'b-1',
              'totalRevenue': 15400.0,
              'completedWorkOrdersCount': 42,
              'totalAppointmentsCount': 55,
              'lowStockAlertsCount': 3,
              'dtcAlertsCount': 4,
            }),
            200,
          );
        }
        if (request.url.path == ApiConstants.analyticsEmployeeSummary) {
          return http.Response(
            jsonEncode({
              'employeeId': 'emp-1',
              'branchIds': ['b-1'],
              'assignedWorkOrdersCount': 3,
              'pendingTasksCount': 1,
              'completedTasksCount': 18,
              'activeDtcAlertsCount': 2,
              'assignedWorkOrders': [],
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = AnalyticsRepositoryImpl(
        analyticsApi: AnalyticsApi(apiClient),
      );
      final getAnalytics = GetAnalytics(repository);

      final branch = await getAnalytics.branchSummary('b-1');
      expect(branch.totalRevenue, 15400.0);
      expect(branch.completedWorkOrdersCount, 42);

      final employee = await getAnalytics.employeeSummary();
      expect(employee.employeeId, 'emp-1');
      expect(employee.completedTasksCount, 18);
    });
  });
}
