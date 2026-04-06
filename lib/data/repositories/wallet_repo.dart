import 'package:isar/isar.dart';
import '../models/wallet_model.dart';

class WalletRepo {
  final Isar isar;

  WalletRepo(this.isar);

  Future<List<Wallet>> getAll() async {
    return isar.wallets.where().sortBySortOrder().findAll();
  }

  Future<Wallet?> getById(int id) async {
    return isar.wallets.get(id);
  }

  Future<int> add(Wallet wallet) async {
    return isar.writeTxn(() async {
      return isar.wallets.put(wallet);
    });
  }

  Future<void> update(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.wallets.delete(id);
    });
  }

  Future<void> updateBalance(int walletId, double amount) async {
    await isar.writeTxn(() async {
      final wallet = await isar.wallets.get(walletId);
      if (wallet != null) {
        wallet.balance += amount;
        await isar.wallets.put(wallet);
      }
    });
  }

  Future<void> transfer(int fromId, int toId, double amount) async {
    await isar.writeTxn(() async {
      final from = await isar.wallets.get(fromId);
      final to = await isar.wallets.get(toId);
      if (from != null && to != null) {
        from.balance -= amount;
        to.balance += amount;
        await isar.wallets.put(from);
        await isar.wallets.put(to);
      }
    });
  }

  Future<double> getTotalBalance() async {
    final wallets = await getAll();
    double total = 0;
    for (final w in wallets) {
      total += w.balance;
    }
    return total;
  }
}
