
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mortgage_calculator.dart';

class MortgageModel extends ChangeNotifier {
  MortgageModel(this._preferences);

  final SharedPreferences _preferences;

  static const _amountKey = 'mortgage_loan_amount';
  static const _yearsKey = 'mortgage_loan_years';
  static const _interestKey = 'mortgage_annual_interest_rate';

  double get loanAmount =>
      _preferences.getDouble(_amountKey) ?? 100000.00;

  int get years =>
      _preferences.getInt(_yearsKey) ?? 30;

  double get annualInterestRate =>
      _preferences.getDouble(_interestKey) ?? 0.035;

  MortgageResult get result => calculateMortgage(
        loanAmount: loanAmount,
        years: years,
        annualInterestRate: annualInterestRate,
      );

  Future<void> saveLoan({
    required double amount,
    required int termYears,
    required double interestRate,
  }) async {
    await _preferences.setDouble(_amountKey, amount);
    await _preferences.setInt(_yearsKey, termYears);
    await _preferences.setDouble(
      _interestKey,
      interestRate,
    );

    notifyListeners();
  }
}
