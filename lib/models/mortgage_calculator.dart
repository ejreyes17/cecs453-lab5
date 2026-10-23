
import 'dart:math' as math;

class MortgageResult {
  const MortgageResult({
    required this.monthlyPayment,
    required this.totalPayment,
  });

  final double monthlyPayment;
  final double totalPayment;
}

MortgageResult calculateMortgage({
  required double loanAmount,
  required int years,
  required double annualInterestRate,
}) {
  if (!loanAmount.isFinite || loanAmount <= 0) {
    throw ArgumentError.value(
      loanAmount,
      'loanAmount',
      'Must be positive',
    );
  }

  if (years <= 0) {
    throw ArgumentError.value(
      years,
      'years',
      'Must be positive',
    );
  }

  if (!annualInterestRate.isFinite ||
      annualInterestRate < 0) {
    throw ArgumentError.value(
      annualInterestRate,
      'annualInterestRate',
      'Cannot be negative',
    );
  }

  final numberOfPayments = years * 12;
  final monthlyRate = annualInterestRate / 12;

  if (monthlyRate == 0) {
    final monthly = loanAmount / numberOfPayments;

    return MortgageResult(
      monthlyPayment: monthly,
      totalPayment: monthly * numberOfPayments,
    );
  }

  final compound =
      math.pow(1 + monthlyRate, numberOfPayments).toDouble();

  final monthly =
      loanAmount * monthlyRate * compound / (compound - 1);

  return MortgageResult(
    monthlyPayment: monthly,
    totalPayment: monthly * numberOfPayments,
  );
}
