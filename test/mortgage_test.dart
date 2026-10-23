import 'package:flutter_test/flutter_test.dart';
import '../lib/models/mortgage_calculator.dart';
import '../lib/models/mortgage_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('30-year mortgage calculation', () {
    final result = calculateMortgage(
      loanAmount: 100000,
      years: 30,
      annualInterestRate: 0.035,
    );

    expect(
      result.monthlyPayment,
      closeTo(449.04469, 0.0001),
    );

    expect(
      result.totalPayment,
      closeTo(161656.08761, 0.0001),
    );
  });

  test('0% interest rate does not divide by zero', () {
    final result = calculateMortgage(
      loanAmount: 12000,
      years: 10,
      annualInterestRate: 0,
    );

    expect(result.monthlyPayment, 100);
    expect(result.totalPayment, 12000);
  });

  test('SharedPreferences saves mortgage inputs', () async {
    SharedPreferences.setMockInitialValues({});

    final preferences =
        await SharedPreferences.getInstance();

    final model = MortgageModel(preferences);

    await model.saveLoan(
      amount: 150000,
      termYears: 15,
      interestRate: 0.045,
    );

    final loaded = MortgageModel(preferences);

    expect(loaded.loanAmount, 150000);
    expect(loaded.years, 15);
    expect(loaded.annualInterestRate, 0.045);
  });
}
