import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:quiz_app/widgets/glitch_text.dart';
import 'package:quiz_app/widgets/scanlines.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _answerController = TextEditingController();
  String _question = "Press START to begin the protocol.";
  String _status = "Awaiting handshake…";
  String _sessionId = "user_${DateTime.now().millisecondsSinceEpoch}";
  int _stage = 0; // 0 = scramble, 1 = math, 2 = riddle
  bool _loading = false;
  bool _quizCompleted = false;
  String _secretKey = "";

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> startQuiz() async {
    setState(() {
      _loading = true;
      _status = "Starting quiz...";
      _quizCompleted = false;
      _secretKey = "";
      _answerController.clear();
      _stage = 0;
    });

    final res = await ApiService.startQuiz(_sessionId);
    setState(() {
      _loading = false;
    });

    if (res.containsKey('error')) {
      _showSnack(res['error']);
      setState(() => _status = "Failed to start quiz");
      return;
    }

    setState(() {
      _question = res['challenge'] ?? "No question received";
      _status = res['message'] ?? "";
      _stage = 0;
    });
  }

  Future<void> submitAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      _showSnack("Please type an answer.");
      return;
    }

    setState(() {
      _loading = true;
      _status = "Verifying...";
    });

    final res = await ApiService.verifyAnswer(_sessionId, _stage, answer);

    setState(() {
      _loading = false;
    });

    if (res.containsKey('error')) {
      _showSnack(res['error']);
      setState(() => _status = "Network or server error");
      return;
    }

    // update status message from server
    final message = (res['message'] ?? "").toString();
    setState(() => _status = message);

    final correct = res['correct'] == true;

    if (correct) {
      // If server returned a next challenge, show it and advance stage.
      if (res.containsKey('challenge')) {
        setState(() {
          _question = res['challenge'];
          _stage = (_stage + 1).clamp(0, 2);
        });
      } else {
        // No challenge means quiz completed (server returns secret available)
        setState(() => _quizCompleted = true);
        // fetch secret
        final secretRes = await ApiService.getSecret(_sessionId);
        if (secretRes.containsKey('error')) {
          _showSnack(secretRes['error']);
          setState(() => _secretKey = "Error fetching secret");
        } else {
          setState(() => _secretKey = secretRes['secret'] ?? "NO-SECRET");
        }
      }
    } else {
      // incorrect answer:
      // Backend returns "challenge" for either: (a) same riddle retry OR (b) a completely new first scramble after restart.
      if (res.containsKey('challenge')) {
        setState(() {
          _question = res['challenge'];
          // if server message contains "restart" then server reset -> stage back to 0
          final low = message.toLowerCase();
          if (low.contains('restart')) {
            _stage = 0;
          }
          // otherwise keep the current stage (for riddle retry, stage stays at 2)
        });
      } else {
        // no challenge field: just show message
        _showSnack(message.isNotEmpty ? message : "Wrong answer");
      }
    }

    _answerController.clear();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Widget _buildBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueAccent),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18, 
            color: Color(0x4411FFAA), 
            spreadRadius: 1
          )
        ],
      ),
      child: Column(
        children: [
          // Question area with readable glitch text
          _quizCompleted 
            ? GlitchText(
                text: "SECRET KEY → $_secretKey",
                style: const TextStyle(
                  fontFamily: 'monospace', 
                  fontSize: 18, 
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
                isReadable: false, // Secret can have full glitch effect
                enableNoise: true,
              )
            : GlitchText(
                text: _question,
                style: const TextStyle(
                  fontFamily: 'monospace', 
                  fontSize: 18, 
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w500,
                ),
                isReadable: true, // Make questions readable!
                enableNoise: false, // Disable noise for questions
              ),
          const SizedBox(height: 8),
          if (!_quizCompleted)
            Align(
              alignment: Alignment.centerLeft,
              child: GlitchText(
                text: "Status: $_status",
                style: const TextStyle(
                  fontFamily: 'monospace', 
                  fontSize: 12, 
                  color: Colors.cyanAccent
                ),
                isReadable: true, // Make status readable too
                enableNoise: false,
                period: const Duration(milliseconds: 2000),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background scanlines effect
          const Scanlines(
            opacity: 0.08,
            enableMatrix: true,
            enableFlicker: false,
          ),
          
          // Main content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    // Title with glitch effect
                    GlitchText(
                      text: "NEURAL LINK PROTOCOL",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 24,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      isReadable: false,
                      enableNoise: true,
                      period: const Duration(milliseconds: 1500),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildBox(),
                    const SizedBox(height: 18),
                    
                    SizedBox(
                      width: 520,
                      child: TextField(
                        controller: _answerController,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontFamily: 'monospace'
                        ),
                        decoration: const InputDecoration(
                          hintText: "Type your answer (then press SUBMIT)",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: (_) => submitAnswer(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        ElevatedButton(
                          onPressed: _loading ? null : submitAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.greenAccent),
                          ),
                          child: _loading 
                            ? const CircularProgressIndicator() 
                            : const Text('SUBMIT'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _loading ? null : startQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.blueAccent),
                          ),
                          child: const Text('START / RESTART'),
                        ),
                      ]
                    ),
                  ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}