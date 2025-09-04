class NewWalletResult {
  final String address;
  final String? mnemonic;
  final String privateKeyHex;       // don’t persist in clear
  final String encryptedVaultBase64;

  NewWalletResult({
    required this.address,
    required this.privateKeyHex,
    required this.encryptedVaultBase64,
    this.mnemonic,
  });
}

class UnlockedWallet {
  final String address;
  final String mnemonic;
  final String privateKeyHex;

  UnlockedWallet({
    required this.address,
    required this.mnemonic,
    required this.privateKeyHex,
  });
}