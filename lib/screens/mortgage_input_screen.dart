
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/mortgage_model.dart';

class MortgageInputScreen extends StatefulWidget {
  const MortgageInputScreen({super.key});

  @override
  State<MortgageInputScreen> createState() =>
      _MortgageInputScreenState();
}

class _MortgageInputScreenState
    extends State<MortgageInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _interestController = TextEditingController();

  int _selectedYears = 30;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final mortgage = context.read<MortgageModel>();

    _selectedYears = mortgage.years;

    _amountController.text =
        mortgage.loanAmount.toStringAsFixed(2);

    _interestController.text =
        mortgage.annualInterestRate.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _interestController.dispose();

    super.dispose();
  }

  Future<void> _saveAndReturn() async {
    if (!_formKey.currentState!.validate() || _saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final amount =
        double.parse(_amountController.text.trim());

    final interest =
        double.parse(_interestController.text.trim());

    try {
      await context.read<MortgageModel>().saveLoan(
            amount: amount,
            termYears: _selectedYears,
            interestRate: interest,
          );

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save your mortgage data.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MortgageV0'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Years',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 8),

                RadioGroup<int>(
                  groupValue: _selectedYears,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedYears = value;
                      });
                    }
                  },
                  child: const Wrap(
                    spacing: 12,
                    crossAxisAlignment:
                        WrapCrossAlignment.center,
                    children: [
                      _YearRadio(years: 10),
                      _YearRadio(years: 15),
                      _YearRadio(years: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.]'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                    helperText: 'Loan amount in dollars',
                  ),
                  validator: (value) {
                    final number = double.tryParse(
                      (value ?? '').trim(),
                    );

                    if (number == null ||
                        !number.isFinite ||
                        number <= 0) {
                      return 'Enter a loan amount greater than 0.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _interestController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.]'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate',
                    border: OutlineInputBorder(),
                    helperText:
                        'Enter 0.035 for 3.5% annual interest',
                  ),
                  validator: (value) {
                    final number = double.tryParse(
                      (value ?? '').trim(),
                    );

                    if (number == null ||
                        !number.isFinite ||
                        number < 0 ||
                        number > 1) {
                      return 'Enter a decimal rate between 0 and 1.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 35),

                Center(
                  child: ElevatedButton(
                    onPressed:
                        _saving ? null : _saveAndReturn,
                    child: Text(
                      _saving ? 'SAVING...' : 'DONE',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _YearRadio extends StatelessWidget {
  const _YearRadio({
    required this.years,
  });

  final int years;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: years,
        ),
        Text('$years'),
      ],
    );
  }
}
