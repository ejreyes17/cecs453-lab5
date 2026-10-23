
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mortgage_model.dart';
import 'mortgage_input_screen.dart';

class MortgageSummaryScreen extends StatelessWidget {
  const MortgageSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MortgageV0'),
      ),
      body: SafeArea(
        child: Consumer<MortgageModel>(
          builder: (context, mortgage, child) {
            final result = mortgage.result;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _detailRow(
                    'Amount',
                    '\$${mortgage.loanAmount.toStringAsFixed(2)}',
                  ),

                  _detailRow(
                    'Years',
                    '${mortgage.years}',
                  ),

                  _detailRow(
                    'Interest Rate',
                    '${(mortgage.annualInterestRate * 100).toStringAsFixed(2)}%',
                  ),

                  const Divider(
                    color: Colors.red,
                    thickness: 2,
                    height: 26,
                  ),

                  _detailRow(
                    'Monthly Payment',
                    '\$${result.monthlyPayment.toStringAsFixed(2)}',
                  ),

                  _detailRow(
                    'Total Payment',
                    '\$${result.totalPayment.toStringAsFixed(2)}',
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                const MortgageInputScreen(),
                          ),
                        );
                      },
                      child: const Text('MODIFY DATA'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
