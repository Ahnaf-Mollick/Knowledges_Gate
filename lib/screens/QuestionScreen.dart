import 'package:flutter/material.dart';
import 'package:knowledges_gate/Routes.dart';
import 'package:knowledges_gate/helpers/AppTheme.dart';
import 'package:knowledges_gate/helpers/SharedResource.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // ── State ──────────────────────────────────────────────────────────────────
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int _currentIndex = 0;
  String? _selectedId;
  int _marksObtained = 0;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pixora.one/questions.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        final decodedData = jsonDecode(response.body);

        List questionList;

        if (decodedData is List) {
          questionList = decodedData;
        } else {
          questionList = decodedData['data'] ?? [];
        }

        setState(() {
          _questions = questionList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load questions';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Map<String, dynamic> get _currentQuestion => _questions[_currentIndex];

  String get _questionText => (_currentQuestion['question'] ?? '').toString();

  /// Converts the options list to [{id, text}] maps.
  /// id is the index as a string so it matches _correctId below.
  List<Map<String, dynamic>> get _options {
    final raw = _currentQuestion['options'] as List? ?? [];
    return raw.asMap().entries.map((e) {
      final item = e.value;
      if (item is Map) {
        return {
          'id': (item['id'] ?? e.key).toString(),
          'text': (item['text'] ?? item['option_text'] ?? '').toString(),
        };
      }
      // flat string list — id is the index
      return {'id': e.key.toString(), 'text': item.toString()};
    }).toList();
  }

  /// The correct answer is stored as an index integer in static data.
  String get _correctId =>
      (_currentQuestion['answer'] ??
              _currentQuestion['correct_answer'] ??
              _currentQuestion['correct'] ??
              '')
          .toString();

  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  // ── Actions ────────────────────────────────────────────────────────────────
  void _select(String id) {
    if (_selectedId != null) return; // lock after first pick
    setState(() => _selectedId = id);
  }

  void _goNext() {
    // Count mark for this question before advancing
    if (_selectedId == _correctId) _marksObtained++;

    if (!_isLastQuestion) {
      setState(() {
        _currentIndex++;
        _selectedId = null;
      });
      _slideController.forward(from: 0);
    } else {
      // Navigate to result screen
      Get.offAllNamed(
        Routes.RESULTROUTE,
        parameters: {
          'totalmarks': _questions.length.toString(),
          'obtained_marks': _marksObtained.toString(),
          'time_taken': '0', // wire up your timer here when ready
        },
      );
    }
  }

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGINROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  // ── Top bar ────────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        _ScoreBadge(
                          correct: _marksObtained,
                          total: _questions.length,
                        ),
                        const Spacer(),
                        // Logout
                        GestureDetector(
                          onTap: _logOut,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.07),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              size: 18,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: QuestionProgress(
                      current: _currentIndex + 1,
                      total: _questions.length,
                    ),
                  ),

                  // ── Scrollable question body ───────────────────────────────────
                  Expanded(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    _questionText,
                                    style: AppTextStyles.heading1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Image.asset('Assets/flutter_logo.png'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            ..._options.map(
                              (opt) => _OptionTile(
                                optionId: opt['id']!,
                                optionText: opt['text']!,
                                selectedId: _selectedId,
                                correctId: _correctId,
                                onTap: () => _select(opt['id']!),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Bottom navigation ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: _isLastQuestion ? 'Finish' : 'Next',
                            onTap: _selectedId != null ? _goNext : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Score Badge ───────────────────────────────────────────────────────────────
class _ScoreBadge extends StatelessWidget {
  final int correct;
  final int total;
  const _ScoreBadge({required this.correct, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
          const SizedBox(width: 4),
          Text(
            '$correct/$total',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

// ── Option Tile ───────────────────────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final String optionId;
  final String optionText;
  final String? selectedId;
  final String correctId;
  final VoidCallback onTap;

  const _OptionTile({
    required this.optionId,
    required this.optionText,
    required this.selectedId,
    required this.correctId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedId == optionId;
    final hasAnswered = selectedId != null;
    final isCorrect = optionId == correctId;

    Color bgColor = AppColors.tileUnselected;
    Color borderColor = AppColors.tileBorderUnselected;
    Color radioColor = AppColors.tileBorderUnselected;
    Color textColor = AppColors.textDark;

    if (hasAnswered) {
      if (isSelected && isCorrect) {
        bgColor = const Color(0xFFDCFCE7);
        borderColor = AppColors.successGreen;
        radioColor = AppColors.successGreen;
      } else if (isSelected && !isCorrect) {
        bgColor = const Color(0xFFFFE4E6);
        borderColor = AppColors.errorRed;
        radioColor = AppColors.errorRed;
      } else if (isCorrect) {
        bgColor = const Color(0xFFDCFCE7);
        borderColor = AppColors.successGreen;
        radioColor = AppColors.successGreen;
      } else {
        textColor = AppColors.textGrey;
      }
    } else if (isSelected) {
      bgColor = const Color(0xFFF3E8FF);
      borderColor = AppColors.primary;
      radioColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: hasAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.8),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: radioColor, width: 2),
                color: isSelected ? radioColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                optionText,
                style: AppTextStyles.body.copyWith(color: textColor),
              ),
            ),
            if (hasAnswered && isCorrect)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.successGreen,
                size: 20,
              ),
            if (hasAnswered && isSelected && !isCorrect)
              const Icon(
                Icons.cancel_rounded,
                color: AppColors.errorRed,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
