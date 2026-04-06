class ParsedSms {
  final double amount;
  final String type; // 'debit' | 'credit'
  final String? merchant;
  final String bank;

  ParsedSms({
    required this.amount,
    required this.type,
    this.merchant,
    required this.bank,
  });
}

class SmsParserService {
  static final _patterns = <String, List<({RegExp regex, String type})>>{
    'CIB': [
      (
        regex: RegExp(r'Purchase\s+EGP\s*([\d,]+\.?\d*)'),
        type: 'debit',
      ),
      (
        regex: RegExp(r'Withdrawal\s+EGP\s*([\d,]+\.?\d*)'),
        type: 'debit',
      ),
      (
        regex: RegExp(r'Deposit\s+EGP\s*([\d,]+\.?\d*)'),
        type: 'credit',
      ),
    ],
    'NBE': [
      (
        regex: RegExp(r'مبلغ\s*([\d,]+\.?\d*)\s*جنيه'),
        type: 'debit',
      ),
    ],
    'BM': [
      (
        regex: RegExp(r'تم خصم\s*([\d,]+\.?\d*)'),
        type: 'debit',
      ),
      (
        regex: RegExp(r'تم إضافة\s*([\d,]+\.?\d*)'),
        type: 'credit',
      ),
    ],
    'Vodafone': [
      (
        regex: RegExp(r'تم تحويل\s*([\d,]+)\s*جنيه'),
        type: 'debit',
      ),
    ],
    'Instapay': [
      (
        regex: RegExp(r'Amount:\s*([\d,]+\.?\d*)\s*EGP'),
        type: 'debit',
      ),
    ],
    'Souhoola': [
      (
        regex: RegExp(r'قسط.*?([\d,]+\.?\d*)\s*جنيه'),
        type: 'debit',
      ),
    ],
    'Valu': [
      (
        regex: RegExp(r'installment.*?EGP\s*([\d,]+\.?\d*)', caseSensitive: false),
        type: 'debit',
      ),
    ],
  };

  static ParsedSms? parse(String smsBody) {
    for (final entry in _patterns.entries) {
      for (final pattern in entry.value) {
        final match = pattern.regex.firstMatch(smsBody);
        if (match != null) {
          final amountStr = match.group(1)?.replaceAll(',', '') ?? '0';
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > 0) {
            return ParsedSms(
              amount: amount,
              type: pattern.type,
              bank: entry.key,
            );
          }
        }
      }
    }
    return null;
  }
}
