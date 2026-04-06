class InstallmentCalculator {
  static double totalFromRate(double originalPrice, double interestRatePercent) {
    return originalPrice * (1 + interestRatePercent / 100);
  }

  static double monthlyAmount(double totalWithInterest, int totalInstallments) {
    return totalWithInterest / totalInstallments;
  }

  static double interestPerInstallment(
      double totalInterest, int totalInstallments) {
    return totalInterest / totalInstallments;
  }

  static double principalPerInstallment(
      double originalPrice, int totalInstallments) {
    return originalPrice / totalInstallments;
  }

  static double effectiveInterestRate(
      double originalPrice, double totalWithInterest) {
    if (originalPrice == 0) return 0;
    return ((totalWithInterest - originalPrice) / originalPrice) * 100;
  }

  static DateTime expectedEndDate(
      DateTime firstPayment, int totalInstallments, int dayOfMonth) {
    return DateTime(
      firstPayment.year,
      firstPayment.month + totalInstallments - 1,
      dayOfMonth,
    );
  }

  static DateTime nextPaymentDate(
      DateTime firstPayment, int paidInstallments, int dayOfMonth) {
    return DateTime(
      firstPayment.year,
      firstPayment.month + paidInstallments,
      dayOfMonth,
    );
  }

  static int daysUntilNextPayment(DateTime nextPayment) {
    return nextPayment.difference(DateTime.now()).inDays;
  }
}
