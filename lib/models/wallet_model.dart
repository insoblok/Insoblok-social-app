class NewWalletResult {
  final String address; // ETH address (primary)
  final String? mnemonic;
  final String privateKeyHex; // don't persist in clear
  final String encryptedVaultBase64;
  final Map<String, String>
  addresses; // Map of chain -> address (e.g., "ethereum": "0x...", "usdt": "0x...", "xrp": "r...")

  NewWalletResult({
    required this.address,
    required this.privateKeyHex,
    required this.encryptedVaultBase64,
    this.mnemonic,
    Map<String, String>? addresses,
  }) : addresses = addresses ?? {};
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
