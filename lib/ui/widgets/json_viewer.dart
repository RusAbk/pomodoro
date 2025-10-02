import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../core/design_system.dart';

class JsonViewer extends StatefulWidget {
  final dynamic data;
  final String title;

  const JsonViewer({
    super.key,
    required this.data,
    this.title = 'JSON Data',
  });

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prettyJson = const JsonEncoder.withIndent('  ').convert(widget.data);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.darkCardGradient : AppColors.cardGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.medium,
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header с градиентом
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.secondaryGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg),
                      topRight: Radius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(
                          Icons.data_object_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: _isCopied 
                              ? AppColors.successColor.withOpacity(0.2)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: InkWell(
                          onTap: () => _copyToClipboard(context, prettyJson),
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                          child: Icon(
                            _isCopied ? Icons.check_rounded : Icons.copy_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // JSON Content с подсветкой
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: _buildSyntaxHighlightedJson(prettyJson, context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyntaxHighlightedJson(String json, BuildContext context) {
    final lines = json.split('\n');
    return SelectableText.rich(
      TextSpan(
        children: lines.map((line) => _highlightJsonLine(line, context)).toList(),
      ),
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  TextSpan _highlightJsonLine(String line, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Цвета для подсветки
    final keyColor = isDark ? const Color(0xFF93C5FD) : AppColors.primaryColor;
    final stringColor = isDark ? const Color(0xFF86EFAC) : AppColors.successColor;
    final numberColor = isDark ? const Color(0xFFFBBF24) : AppColors.warningColor;
    final boolNullColor = isDark ? const Color(0xFFFC8181) : AppColors.errorColor;
    final punctuationColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    List<TextSpan> spans = [];
    
    // Простая регулярка для базовой подсветки
    final regex = RegExp(r'(".*?")|(\b\d+\.?\d*\b)|(\btrue\b|\bfalse\b|\bnull\b)|([{}[\],:])')
    ;
    
    int lastMatch = 0;
    for (final match in regex.allMatches(line)) {
      // Добавляем текст до совпадения
      if (match.start > lastMatch) {
        spans.add(TextSpan(
          text: line.substring(lastMatch, match.start),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ));
      }
      
      final matchText = match.group(0)!;
      Color color;
      FontWeight? fontWeight;
      
      if (match.group(1) != null) {
        // Строки (включая ключи)
        if (matchText.endsWith('":')) {
          color = keyColor;
          fontWeight = FontWeight.w600;
        } else {
          color = stringColor;
        }
      } else if (match.group(2) != null) {
        // Числа
        color = numberColor;
        fontWeight = FontWeight.w500;
      } else if (match.group(3) != null) {
        // Boolean/null
        color = boolNullColor;
        fontWeight = FontWeight.w600;
      } else {
        // Знаки препинания
        color = punctuationColor;
        fontWeight = FontWeight.bold;
      }
      
      spans.add(TextSpan(
        text: matchText,
        style: TextStyle(
          color: color,
          fontWeight: fontWeight,
        ),
      ));
      
      lastMatch = match.end;
    }
    
    // Добавляем остальной текст
    if (lastMatch < line.length) {
      spans.add(TextSpan(
        text: line.substring(lastMatch) + '\n',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ));
    } else {
      spans.add(const TextSpan(text: '\n'));
    }
    
    return TextSpan(children: spans);
  }

  void _copyToClipboard(BuildContext context, String text) async {
    await _controller.forward();
    await _controller.reverse();
    
    await Clipboard.setData(ClipboardData(text: text));
    
    setState(() => _isCopied = true);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.successColor),
              const SizedBox(width: AppSpacing.sm),
              const Text('JSON скопирован в буфер обмена'),
            ],
          ),
          backgroundColor: AppColors.successColor.withOpacity(0.1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Сброс состояния через 2 секунды
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isCopied = false);
        }
      });
    }
  }
}