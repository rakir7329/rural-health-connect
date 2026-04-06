import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  bool _isSending = false;

  void _triggerSos() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSending = false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Emergency Alert Sent!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('An alert message with your location has been simulated and sent to your emergency contacts.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency SOS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tap in case of emergency', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                .animate().fade(duration: 800.ms).slideY(begin: -0.5, end: 0),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: _isSending ? null : _triggerSos,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.red.shade400, Colors.red.shade700]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _isSending 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SOS', style: TextStyle(color: Colors.white, fontSize: 70, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1000.ms)
               .boxShadow(
                 begin: BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, spreadRadius: 5), 
                 end: BoxShadow(color: Colors.red.withOpacity(0.6), blurRadius: 30, spreadRadius: 15)
               ),
            ),
            const SizedBox(height: 80),
            const Text('This will instantly notify your contacts.', style: TextStyle(color: Colors.grey, fontSize: 16))
                .animate().fade(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
