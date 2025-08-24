import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  // FOR WEB: localhost works for Flutter web
  // If you run on emulator/device, change this to 10.0.2.2 or your PC IP accordingly.
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // Cyberpunk-themed logging
  static final Random _random = Random();
  static const List<String> _hackPrefixes = [
    '>>> ACCESSING MAINFRAME',
    '>>> INITIATING SECURE HANDSHAKE',
    '>>> DECRYPTING NEURAL LINK',
    '>>> BYPASSING FIREWALL',
    '>>> ESTABLISHING QUANTUM TUNNEL',
    '>>> SYNCHRONIZING BIOMETRIC DATA',
  ];
  
  static const List<String> _hackSuffixes = [
    'TRANSMISSION_COMPLETE',
    'DATA_PACKETS_VERIFIED', 
    'ENCRYPTION_VALIDATED',
    'CONNECTION_ESTABLISHED',
    'NEURAL_SYNC_ACTIVE',
    'FIREWALL_BYPASSED',
  ];

  static void _logHackerStyle(String operation) {
    final prefix = _hackPrefixes[_random.nextInt(_hackPrefixes.length)];
    final suffix = _hackSuffixes[_random.nextInt(_hackSuffixes.length)];
    print('$prefix: $operation... $suffix');
  }

  static Future<Map<String, dynamic>> startQuiz(String sessionId) async {
    _logHackerStyle('QUIZ_INITIALIZATION_PROTOCOL');
    
    try {
      final url = Uri.parse('$baseUrl/start_quiz?session_id=$sessionId');
      final resp = await http.get(url);
      
      if (resp.statusCode == 200) {
        _logHackerStyle('CHALLENGE_DATA_RETRIEVED');
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        
        // Add cyberpunk flavor to response messages
        if (data.containsKey('message')) {
          data['message'] = _enhanceMessage(data['message'].toString());
        }
        
        return data;
      } else {
        _logHackerStyle('MAINFRAME_ACCESS_DENIED');
        return {
          'error': '>>> SYSTEM ERROR: Mainframe returned protocol ${resp.statusCode} <<<'
        };
      }
    } catch (e) {
      _logHackerStyle('NETWORK_CONNECTION_FAILED');
      return {
        'error': '>>> FATAL ERROR: Neural link severed - $e <<<'
      };
    }
  }

  static Future<Map<String, dynamic>> verifyAnswer(String sessionId, int stage, String userAnswer) async {
    _logHackerStyle('ANSWER_VERIFICATION_SEQUENCE');
    
    try {
      final url = Uri.parse('$baseUrl/verify_answer');
      final body = jsonEncode({
        'session_id': sessionId,
        'stage': stage,
        'user_answer': userAnswer,
      });
      
      final resp = await http.post(
        url, 
        headers: {
          'Content-Type': 'application/json',
          'X-Cyber-Auth': 'NEURAL_LINK_ACTIVE',
          'User-Agent': 'CyberQuest-Terminal/2.1'
        }, 
        body: body
      );
      
      if (resp.statusCode == 200) {
        _logHackerStyle('BIOMETRIC_VALIDATION_COMPLETE');
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        
        // Enhance response messages with cyberpunk style
        if (data.containsKey('message')) {
          data['message'] = _enhanceMessage(data['message'].toString());
        }
        
        return data;
      } else {
        _logHackerStyle('AUTHENTICATION_REJECTED');
        return {
          'error': '>>> ACCESS DENIED: Security protocol ${resp.statusCode} triggered <<<'
        };
      }
    } catch (e) {
      _logHackerStyle('QUANTUM_TUNNEL_COLLAPSED');
      return {
        'error': '>>> CONNECTION ERROR: Quantum entanglement failed - $e <<<'
      };
    }
  }

  static Future<Map<String, dynamic>> getSecret(String sessionId) async {
    _logHackerStyle('SECRET_KEY_EXTRACTION_PROTOCOL');
    
    try {
      final url = Uri.parse('$baseUrl/get_secret?session_id=$sessionId');
      final resp = await http.get(
        url,
        headers: {
          'X-Clearance-Level': 'OMEGA',
          'X-Neural-ID': sessionId,
        }
      );
      
      if (resp.statusCode == 200) {
        _logHackerStyle('CLASSIFIED_DATA_DECRYPTED');
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        
        // Add cyberpunk styling to secret
        if (data.containsKey('secret')) {
          final secret = data['secret'].toString();
          data['secret'] = '▓▓▓ CLASSIFIED ▓▓▓ $secret ▓▓▓ CLASSIFIED ▓▓▓';
        }
        
        return data;
      } else {
        _logHackerStyle('SECURITY_LOCKDOWN_INITIATED');
        return {
          'error': '>>> CLASSIFIED: Security clearance ${resp.statusCode} required <<<'
        };
      }
    } catch (e) {
      _logHackerStyle('DECRYPTION_MATRIX_FAILURE');
      return {
        'error': '>>> SECURITY BREACH: Encryption matrix corrupted - $e <<<'
      };
    }
  }

  // Enhance messages with cyberpunk styling
  static String _enhanceMessage(String message) {
    final enhancements = [
      '░▒▓ ',
      '▓▒░ ', 
      '>>> ',
      '<<< ',
      '█▓▒ ',
      '▒▓█ ',
    ];
    
    final prefix = enhancements[_random.nextInt(enhancements.length)];
    final suffix = enhancements[_random.nextInt(enhancements.length)];
    
    return '$prefix$message$suffix';
  }

  // Additional cyberpunk utility methods
  static String generateCyberSessionId() {
    const chars = '0123456789ABCDEF';
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    String hexId = '';
    for (int i = 0; i < 8; i++) {
      hexId += chars[random.nextInt(chars.length)];
    }
    
    return 'NEURAL_${timestamp.toRadixString(16).toUpperCase()}_$hexId';
  }

  static Map<String, String> getCyberHeaders() {
    return {
      'X-Protocol': 'CYBERNET_2.1',
      'X-Encryption': 'QUANTUM_AES_256',
      'X-Terminal': 'HACKER_WORKSTATION',
      'User-Agent': 'CyberGhost/Neural-Link-Active',
    };
  }
}