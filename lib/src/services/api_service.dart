import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Assuming Android emulator uses 10.0.2.2, but for Windows desktop it's localhost
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // --- Auth API ---

  Future<String> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Assuming register returns user object or id, or just success
        // Based on prompt, only login returns userId explicitly mentioned,
        // but typically register might too or just 200 OK.
        // Let's assume 200 OK and we can login after.
        return 'success';
      } else {
        throw Exception(
          'Register failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = response.body;
        try {
          // Attempt 1: Parse as JSON
          dynamic data;
          try {
            data = jsonDecode(body);
          } catch (_) {
            // Not JSON? Maybe just a plain string ID (legacy or simple API)
            // If body is not empty and doesn't look like JSON/HTML error
            if (body.isNotEmpty &&
                !body.startsWith('<') &&
                !body.startsWith('{')) {
              return {'id': body.trim(), 'username': username};
            }
            rethrow;
          }

          if (data is Map) {
            // Case A: { "userId": { "id": "...", "username": "..." } }
            if (data.containsKey('userId')) {
              final userId = data['userId'];
              if (userId is Map) {
                return Map<String, dynamic>.from(userId);
              } else if (userId is String) {
                // Case B: { "userId": "uuid-string" }
                return {'id': userId, 'username': username};
              }
            }
            // Case C: The whole object is the user? { "id": "...", "username": "..." }
            if (data.containsKey('id') && data.containsKey('username')) {
              return Map<String, dynamic>.from(data);
            }
            // Case D: Maybe just ID in a map? { "id": "..." }
            if (data.containsKey('id')) {
              return {'id': data['id'], 'username': username};
            }
          } else if (data is String) {
            // Case E: JSON string "uuid-string"
            return {'id': data, 'username': username};
          }

          throw Exception('Invalid login response format: $body');
        } catch (e) {
          // Include body in error for debugging
          throw Exception('Invalid login response body: $e. Body: $body');
        }
      } else {
        throw Exception(
          'Login failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await http.post(Uri.parse('$baseUrl/auth/logout'));
    } catch (_) {
      // Ignore errors on logout
    }
  }

  // --- Battle API ---

  Future<Map<String, dynamic>> startBattle(String enemyId) async {
    // Mock implementation for now, assuming backend will have this
    // Or if I need to implement client-side simulation via API wrapper,
    // but the prompt says "connect to interfaces", implying they exist or I should define them.
    // Given the previous pattern, I'll define them and handle errors or mock if needed.
    // For now, let's assume standard endpoints.
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/battles/start'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enemyId': enemyId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
          'Start battle failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<Map<String, dynamic>> battleAction(
    String battleId,
    String actionType, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final body = {'type': actionType, if (params != null) 'params': params};
      final response = await http.post(
        Uri.parse('$baseUrl/battles/$battleId/action'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
          'Battle action failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  // --- Drops API ---

  Future<List<dynamic>> generateDrops(
    String sourceId,
    String sourceType,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/drops/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sourceId': sourceId, 'sourceType': sourceType}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
          'Generate drops failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  // --- Game Data API ---

  Future<List<dynamic>> fetchTraits() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game-data/traits'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        // Fallback or empty if not found
        debugPrint('Fetch traits failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Connection failed when fetching traits: $e');
      return [];
    }
  }

  // --- Character API ---

  Future<Map<String, dynamic>> createCharacter(
    Map<String, dynamic> characterData, {
    Map<String, dynamic>? userId,
  }) async {
    final payload = {...characterData};
    if (userId != null) {
      payload['userId'] = userId;
    }

    try {
      final body = jsonEncode(payload);
      final response = await http.post(
        Uri.parse('$baseUrl/characters'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
          'Create character failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<List<dynamic>> listCharacters({Map<String, dynamic>? userId}) async {
    try {
      String? idStr;
      if (userId != null) {
        idStr = userId['id']?.toString();
      }

      final url = idStr != null
          ? '$baseUrl/characters?userId=$idStr'
          : '$baseUrl/characters';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('List characters failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  // --- Player Save API ---

  Future<Map<String, dynamic>> createSave(
    String name,
    Map<String, dynamic> payload, {
    Map<String, dynamic>? userId,
  }) async {
    final body = {'name': name, 'payload': payload};
    if (userId != null) {
      body['userId'] = userId;
    }

    try {
      final jsonBody = jsonEncode(body);

      final response = await http.post(
        Uri.parse('$baseUrl/players'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
          'Create save failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<Map<String, dynamic>> updateSave(
    String id,
    String name,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/players/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'payload': payload}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
          'Update save failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<List<dynamic>> listSaves({Map<String, dynamic>? userId}) async {
    try {
      String? idStr;
      if (userId != null) {
        idStr = userId['id']?.toString();
      }

      final url = idStr != null
          ? '$baseUrl/players?userId=$idStr&includePayload=false'
          : '$baseUrl/players?includePayload=false';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('List saves failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<Map<String, dynamic>> getSave(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$id?includePayload=true'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Get save failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<void> deleteSave(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/players/$id'));
      if (response.statusCode != 200) {
        throw Exception('Delete save failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
