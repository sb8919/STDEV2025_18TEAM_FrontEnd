import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import '../widgets/body_part_selector.dart';
import '../services/symptom_service.dart';

class SymptomSelectionScreen extends StatefulWidget {
  final Set<BodyPart> selectedBodyParts;

  const SymptomSelectionScreen({
    super.key,
    required this.selectedBodyParts,
  });

  @override
  State<SymptomSelectionScreen> createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen> {
  String? _selectedSymptom;
  String? _selectedFeeling;
  List<String> _feelings = [];
  bool _isLoading = false;
  final SymptomService _symptomService = SymptomService();
  
  final List<String> _symptoms = [
    '통증',
    '부종',
    '발열',
    '가려움',
    '저림',
  ];

  Future<void> _onSymptomSelected(String symptom) async {
    setState(() {
      _selectedSymptom = symptom;
      _isLoading = true;
      _selectedFeeling = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final loginId = prefs.getString('login_id');
      
      if (loginId != null) {
        final bodyParts = widget.selectedBodyParts.map((part) => part.toString().split('.').last).toSet();
        final feelings = await _symptomService.getSymptomFeelings(loginId, bodyParts, symptom);
        
        setState(() {
          _feelings = feelings;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading feelings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFeelingSelected(String feeling) {
    setState(() {
      _selectedFeeling = feeling;
    });
  }

  void _onCompleteSelection() {
    if (_selectedSymptom == null || _selectedFeeling == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          selectedBodyParts: widget.selectedBodyParts,
          symptom: '$_selectedSymptom ($_selectedFeeling)',
          duration: '',
          painIntensity: 0.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                '어떤 증상이 느껴지나요?',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ..._symptoms.map((symptom) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ElevatedButton(
                onPressed: () => _onSymptomSelected(symptom),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedSymptom == symptom 
                      ? const Color(0xFF394BF5)
                      : Colors.grey[200],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  symptom,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _selectedSymptom == symptom 
                        ? Colors.white 
                        : Colors.black,
                  ),
                ),
              ),
            )).toList(),
            if (_selectedSymptom != null) ...[
              const SizedBox(height: 30),
              const Text(
                '증상이 어떻게 느껴지나요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ..._feelings.map((feeling) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => _onFeelingSelected(feeling),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedFeeling == feeling 
                          ? const Color(0xFF394BF5)
                          : Colors.grey[200],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      feeling,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _selectedFeeling == feeling 
                            ? Colors.white 
                            : Colors.black,
                      ),
                    ),
                  ),
                )).toList(),
            ],
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedSymptom != null && _selectedFeeling != null 
                      ? _onCompleteSelection 
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF394BF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    '선택 완료',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 