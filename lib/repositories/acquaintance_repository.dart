import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/member.dart';

class AcquaintanceRepository {
  Future<List<Acquaintance>> getAcquaintances(String loginId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        if (userData['loginId'] == loginId) {
          final acquaintances = (userData['acquaintances'] as List)
              .map((a) => Acquaintance(
                    name: a['name'],
                    relationship: a['relationship'],
                    imagePath: a['imagePath'],
                    healthMetrics: HealthMetrics(
                      metrics: (a['healthMetrics']['metrics'] as List)
                          .map((m) => MetricData(
                                name: m['name'],
                                value: m['value'],
                                severityLevel: m['severityLevel'],
                              ))
                          .toList(),
                    ),
                  ))
              .toList();
          return acquaintances;
        }
      }
      return [];
    } catch (e) {
      print('Error getting acquaintances: $e');
      return [];
    }
  }

  Future<void> updateAcquaintance(Acquaintance acquaintance) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        final acquaintances = (userData['acquaintances'] as List?)
            ?.map((a) => {
                  'name': a['name'],
                  'relationship': a['relationship'],
                  'imagePath': a['imagePath'],
                  'healthMetrics': {
                    'metrics': (a['healthMetrics']['metrics'] as List)
                        .map((m) => {
                              'name': m['name'],
                              'value': m['value'],
                              'severityLevel': m['severityLevel'],
                            })
                        .toList(),
                  },
                })
            .toList() ?? [];

        final acquaintanceIndex = acquaintances.indexWhere(
          (a) => a['name'] == acquaintance.name,
        );

        if (acquaintanceIndex != -1) {
          acquaintances[acquaintanceIndex] = {
            'name': acquaintance.name,
            'relationship': acquaintance.relationship,
            'imagePath': acquaintance.imagePath,
            'healthMetrics': {
              'metrics': acquaintance.healthMetrics.metrics
                  .map((m) => {
                        'name': m.name,
                        'value': m.value,
                        'severityLevel': m.severityLevel,
                      })
                  .toList(),
            },
          };

          userData['acquaintances'] = acquaintances;
          await prefs.setString('user_data', jsonEncode(userData));
        }
      }
    } catch (e) {
      print('Error updating acquaintance: $e');
      throw Exception('Failed to update acquaintance');
    }
  }
} 