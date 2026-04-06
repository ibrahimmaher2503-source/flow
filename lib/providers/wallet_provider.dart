import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/wallet_model.dart';
import '../data/repositories/wallet_repo.dart';
import '../data/services/isar_service.dart';

final walletRepoProvider = Provider<WalletRepo>((ref) {
  return WalletRepo(ref.watch(isarProvider));
});

final walletsProvider = FutureProvider<List<Wallet>>((ref) async {
  final repo = ref.watch(walletRepoProvider);
  return repo.getAll();
});

final totalBalanceProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(walletRepoProvider);
  return repo.getTotalBalance();
});

void refreshWallets(WidgetRef ref) {
  ref.invalidate(walletsProvider);
  ref.invalidate(totalBalanceProvider);
}
