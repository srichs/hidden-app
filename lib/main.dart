import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'hidden/hidden_app.dart';
import 'security/secret.dart';

void main() {
  runApp(const HiddenAppCalculator());
}

class HiddenAppCalculator extends StatelessWidget {
  const HiddenAppCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const String _kHashedSecret =
      '833dfc7e3eb11230369904322cc8481b2b9a166d965557f97d4832cd92e072af';

  final SecretValidator _secretValidator =
      SecretValidator(hashedSecret: _kHashedSecret);

  final List<List<String>> _buttonLayout = const <List<String>>[
    <String>['7', '8', '9', '/'],
    <String>['4', '5', '6', '*'],
    <String>['1', '2', '3', '-'],
    <String>['C', '0', '.', '+'],
    <String>['⌫', '='],
  ];

  String _input = '';
  String _result = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Calculator'),
      ),
      body: Column(
        children: <Widget>[
          _DisplayPanel(input: _input, result: _result),
          const Divider(height: 1),
          Expanded(
            child: Column(
              children: _buttonLayout
                  .map((List<String> row) => _buildButtonRow(row))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels
            .map((String label) => Expanded(
                    child: _CalculatorButton(
                  label: label,
                  onPressed: () => _handleButtonPress(label),
                )))
            .toList(),
      ),
    );
  }

  void _handleButtonPress(String label) {
    switch (label) {
      case 'C':
        _clearInput();
        break;
      case '⌫':
        _deleteLastCharacter();
        break;
      case '=':
        _handleEquals();
        break;
      default:
        _appendInput(label);
    }
  }

  void _appendInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void _clearInput() {
    setState(() {
      _input = '';
      _result = '0';
    });
  }

  void _deleteLastCharacter() {
    if (_input.isEmpty) {
      return;
    }
    setState(() {
      _input = _input.substring(0, _input.length - 1);
    });
  }

  void _handleEquals() {
    final String sanitized = _removeWhitespace(_input);
    if (sanitized.isEmpty) {
      return;
    }

    if (_secretValidator.isSecretInput(sanitized)) {
      _openHiddenApp();
      return;
    }

    try {
      final String replaced =
          sanitized.replaceAll('÷', '/').replaceAll('×', '*');
      final Parser parser = Parser();
      final Expression expression = parser.parse(replaced);
      final double value = expression
          .evaluate(EvaluationType.REAL, ContextModel())
          .toDouble();
      setState(() {
        _result = _formatResult(value);
      });
    } on FormatException catch (error) {
      _showError(error.message);
    } on ArgumentError catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Unable to evaluate expression.');
    }
  }

  void _openHiddenApp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HiddenAppPlaceholder(),
      ),
    );
    _clearInput();
  }

  String _formatResult(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    var text = value.toString();
    while (text.contains('.') && text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _removeWhitespace(String value) {
    final StringBuffer buffer = StringBuffer();
    for (final int codeUnit in value.codeUnits) {
      if (!_isWhitespace(codeUnit)) {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString();
  }

  bool _isWhitespace(int codeUnit) {
    return codeUnit == 0x20 || codeUnit == 0x0A || codeUnit == 0x09;
  }
}

class _DisplayPanel extends StatelessWidget {
  const _DisplayPanel({
    required this.input,
    required this.result,
  });

  final String input;
  final String result;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            input,
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            result,
            style:
                textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
