import 'package:flutter/material.dart';

class IconResolver {
  static const _iconMap = <String, IconData>{
    'restaurant': Icons.restaurant,
    'shopping_cart': Icons.shopping_cart,
    'smoking_rooms': Icons.smoking_rooms,
    'sports_esports': Icons.sports_esports,
    'nightlife': Icons.nightlife,
    'favorite': Icons.favorite,
    'home': Icons.home,
    'house': Icons.house,
    'groups': Icons.groups,
    'credit_card': Icons.credit_card,
    'directions_car': Icons.directions_car,
    'receipt': Icons.receipt,
    'medical_services': Icons.medical_services,
    'school': Icons.school,
    'subscriptions': Icons.subscriptions,
    'checkroom': Icons.checkroom,
    'card_giftcard': Icons.card_giftcard,
    'more_horiz': Icons.more_horiz,
    'payments': Icons.payments,
    'work': Icons.work,
    'redeem': Icons.redeem,
    'replay': Icons.replay,
    'add_circle': Icons.add_circle,
    'wallet': Icons.wallet,
    'account_balance': Icons.account_balance,
    'phone_android': Icons.phone_android,
    'diamond': Icons.diamond,
    'shield': Icons.shield,
    'credit_score': Icons.credit_score,
    'savings': Icons.savings,
    'attach_money': Icons.attach_money,
    'account_balance_wallet': Icons.account_balance_wallet,
  };

  static IconData resolve(String name) {
    return _iconMap[name] ?? Icons.category;
  }
}
