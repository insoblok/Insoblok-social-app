import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:reown_appkit/reown_appkit.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

enum SupportedMethods {
  personalSign,
  ethSendTransaction,
  requestAccounts,
  ethSignTypedData,
  ethSignTypedDataV3,
  ethSignTypedDataV4,
  ethSignTransaction,
  walletWatchAsset,
  solanaSignMessage;

  String get name {
    switch (this) {
      case personalSign:
        return 'personal_sign';
      case ethSignTypedDataV4:
        return 'eth_signTypedData_v4';
      case ethSendTransaction:
        return 'eth_sendTransaction';
      case requestAccounts:
        return 'eth_requestAccounts';
      case ethSignTypedDataV3:
        return 'eth_signTypedData_v3';
      case ethSignTypedData:
        return 'eth_signTypedData';
      case ethSignTransaction:
        return 'eth_signTransaction';
      case walletWatchAsset:
        return 'wallet_watchAsset';
      case solanaSignMessage:
        return 'solana_signMessage';
    }
  }
}

class ReownService {
  late ReownAppKitModal _appKitModel;
  ReownAppKitModal get appKitModel => _appKitModel;

  Future<void> init(BuildContext context) async {
    _appKitModel = ReownAppKitModal(
      context: context,
      projectId: kReownProjectID,
      metadata: const PairingMetadata(
        name: 'insoblokai',
        description: 'insoblokai.io',
        url: 'https://www.insoblokai.io/',
        icons: [
          'https://firebasestorage.googleapis.com/v0/b/insoblokai.firebasestorage.app/o/ic_inso.png?alt=media&token=78ee384d-c7c3-4d8f-b7c1-5fcecbe0e202',
        ],
        redirect: Redirect(
          native: 'insoblokai://',
          universal: 'https://www.insoblokai.io/insoblokai',
          linkMode: false,
        ),
      ),
    );

    await _appKitModel.init();
    DeepLinkHandler.init(_appKitModel);
  }

  Future<void> connect() async {
    if (!isConnected) {
      await _appKitModel.openModalView(ReownAppKitModalMainWalletsPage());
    }
  }

  bool get isConnected => appKitModel.isConnected;

  String? get chainID => appKitModel.selectedChain?.chainId;
  String? get namespace =>
      chainID == null ? null : NamespaceUtils.getNamespaceFromChain(chainID!);
  String? get walletAddress =>
      namespace == null ? null : appKitModel.session?.getAddress(namespace!);

  DeployedContract? get deployedContract =>
      walletAddress == null
          ? null
          : DeployedContract(
            ContractAbi.fromJson(jsonEncode(contractABI), namespace ?? 'ETH'),
            EthereumAddress.fromHex(walletAddress!),
          );

  Future<List<dynamic>> get balanceOf => appKitModel.requestReadContract(
    deployedContract: deployedContract!,
    topic: appKitModel.session!.topic,
    chainId: chainID!,
    functionName: 'balanceOf',
    parameters: [EthereumAddress.fromHex(walletAddress!)],
  );

  Future<List<dynamic>> get totalSupply => appKitModel.requestReadContract(
    deployedContract: deployedContract!,
    topic: appKitModel.session!.topic,
    chainId: appKitModel.selectedChain!.chainId,
    functionName: 'totalSupply',
  );

  Future<dynamic> ethSendTransaction({
    required String recipientAddress,
    required int amount,
    EtherUnit unit = EtherUnit.szabo,
  }) async {
    logger.d(walletAddress);
    logger.d(recipientAddress);
    return await _appKitModel.request(
      topic: _appKitModel.session!.topic,
      chainId: _appKitModel.selectedChain!.chainId,
      request: SessionRequestParams(
        method: SupportedMethods.ethSendTransaction.name,
        params: [
          Transaction(
            from: EthereumAddress.fromHex(walletAddress ?? ''),
            to: EthereumAddress.fromHex(recipientAddress),
            value: EtherAmount.fromInt(unit, amount),
            data: utf8.encode('0x'),
          ).toJson(),
        ],
      ),
    );
  }

  String typedData =
      r'''{"types":{"EIP712Domain":[{"type":"string","name":"name"},{"type":"string","name":"version"},{"type":"uint256","name":"chainId"},{"type":"address","name":"verifyingContract"}],"Part":[{"name":"account","type":"address"},{"name":"value","type":"uint96"}],"Mint721":[{"name":"tokenId","type":"uint256"},{"name":"tokenURI","type":"string"},{"name":"creators","type":"Part[]"},{"name":"royalties","type":"Part[]"}]},"domain":{"name":"Mint721","version":"1","chainId":4,"verifyingContract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce"},"primaryType":"Mint721","message":{"@type":"ERC721","contract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce","tokenId":"1","uri":"ipfs://ipfs/hash","creators":[{"account":"0xc5eac3488524d577a1495492599e8013b1f91efa","value":10000}],"royalties":[],"tokenURI":"ipfs://ipfs/hash"}}''';

  // Map<String, dynamic> typeDataV3(int chainId) => {
  //   'types': {
  //     'EIP712Domain': [
  //       {'name': 'name', 'type': 'string'},
  //       {'name': 'version', 'type': 'string'},
  //       {'name': 'chainId', 'type': 'uint256'},
  //       {'name': 'verifyingContract', 'type': 'address'},
  //     ],
  //     'Person': [
  //       {'name': 'name', 'type': 'string'},
  //       {'name': 'wallet', 'type': 'address'},
  //     ],
  //     'Mail': [
  //       {'name': 'from', 'type': 'Person'},
  //       {'name': 'to', 'type': 'Person'},
  //       {'name': 'contents', 'type': 'string'},
  //     ],
  //   },
  //   'primaryType': 'Mail',
  //   'domain': {
  //     'name': 'Ether Mail',
  //     'version': '1',
  //     'chainId': chainId,
  //     'verifyingContract': walletAddress,
  //   },
  //   'message': {
  //     'from': {'name': 'Cow', 'wallet': walletAddress},
  //     'to': {'name': 'Bob', 'wallet': walletAddress},
  //     'contents': 'Hello, Bob!',
  //   },
  // };

  // Map<String, dynamic> typeDataV4(int chainId) => {
  //   'types': {
  //     'EIP712Domain': [
  //       {'type': 'string', 'name': 'name'},
  //       {'type': 'string', 'name': 'version'},
  //       {'type': 'uint256', 'name': 'chainId'},
  //       {'type': 'address', 'name': 'verifyingContract'},
  //     ],
  //     'Part': [
  //       {'name': 'account', 'type': 'address'},
  //       {'name': 'value', 'type': 'uint96'},
  //     ],
  //     'Mint721': [
  //       {'name': 'tokenId', 'type': 'uint256'},
  //       {'name': 'tokenURI', 'type': 'string'},
  //       {'name': 'creators', 'type': 'Part[]'},
  //       {'name': 'royalties', 'type': 'Part[]'},
  //     ],
  //   },
  //   'domain': {
  //     'name': 'Mint721',
  //     'version': '1',
  //     'chainId': chainId,
  //     'verifyingContract': walletAddress,
  //   },
  //   'primaryType': 'Mint721',
  //   'message': {
  //     '@type': 'ERC721',
  //     'contract': walletAddress,
  //     'tokenId': '1',
  //     'uri': 'ipfs://ipfs/hash',
  //     'creators': [
  //       {'account': walletAddress, 'value': 10000},
  //     ],
  //     'royalties': [],
  //     'tokenURI': 'ipfs://ipfs/hash',
  //   },
  // };

  List<Map<String, dynamic>> get contractABI => [
    {
      'inputs': [
        {'internalType': 'string', 'name': 'name', 'type': 'string'},
        {'internalType': 'string', 'name': 'symbol', 'type': 'string'},
        {'internalType': 'uint8', 'name': 'decimals', 'type': 'uint8'},
        {'internalType': 'address', 'name': 'owner', 'type': 'address'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'constructor',
    },
    {
      'anonymous': false,
      'inputs': [
        {
          'indexed': true,
          'internalType': 'address',
          'name': 'owner',
          'type': 'address',
        },
        {
          'indexed': true,
          'internalType': 'address',
          'name': 'spender',
          'type': 'address',
        },
        {
          'indexed': false,
          'internalType': 'uint256',
          'name': 'value',
          'type': 'uint256',
        },
      ],
      'name': 'Approval',
      'type': 'event',
    },
    {
      'anonymous': false,
      'inputs': [
        {
          'indexed': true,
          'internalType': 'address',
          'name': 'previousOwner',
          'type': 'address',
        },
        {
          'indexed': true,
          'internalType': 'address',
          'name': 'newOwner',
          'type': 'address',
        },
      ],
      'name': 'OwnershipTransferred',
      'type': 'event',
    },
    {
      'anonymous': false,
      'inputs': [
        {
          'indexed': true,
          'internalType': 'address',
          'name': 'from',
          'type': 'address',
        },
        {
          'indexed': true,
          'internalType': 'address',
          'name': 'to',
          'type': 'address',
        },
        {
          'indexed': false,
          'internalType': 'uint256',
          'name': 'value',
          'type': 'uint256',
        },
      ],
      'name': 'Transfer',
      'type': 'event',
    },
    {
      'inputs': [],
      'name': 'DOMAIN_SEPARATOR',
      'outputs': [
        {'internalType': 'bytes32', 'name': '', 'type': 'bytes32'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'EIP712_REVISION',
      'outputs': [
        {'internalType': 'bytes', 'name': '', 'type': 'bytes'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'PERMIT_TYPEHASH',
      'outputs': [
        {'internalType': 'bytes32', 'name': '', 'type': 'bytes32'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'owner', 'type': 'address'},
        {'internalType': 'address', 'name': 'spender', 'type': 'address'},
      ],
      'name': 'allowance',
      'outputs': [
        {'internalType': 'uint256', 'name': '', 'type': 'uint256'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'spender', 'type': 'address'},
        {'internalType': 'uint256', 'name': 'amount', 'type': 'uint256'},
      ],
      'name': 'approve',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'account', 'type': 'address'},
      ],
      'name': 'balanceOf',
      'outputs': [
        {'internalType': 'uint256', 'name': '', 'type': 'uint256'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'decimals',
      'outputs': [
        {'internalType': 'uint8', 'name': '', 'type': 'uint8'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'spender', 'type': 'address'},
        {
          'internalType': 'uint256',
          'name': 'subtractedValue',
          'type': 'uint256',
        },
      ],
      'name': 'decreaseAllowance',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'spender', 'type': 'address'},
        {'internalType': 'uint256', 'name': 'addedValue', 'type': 'uint256'},
      ],
      'name': 'increaseAllowance',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'account', 'type': 'address'},
        {'internalType': 'uint256', 'name': 'value', 'type': 'uint256'},
      ],
      'name': 'mint',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'uint256', 'name': 'value', 'type': 'uint256'},
      ],
      'name': 'mint',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'name',
      'outputs': [
        {'internalType': 'string', 'name': '', 'type': 'string'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'owner', 'type': 'address'},
      ],
      'name': 'nonces',
      'outputs': [
        {'internalType': 'uint256', 'name': '', 'type': 'uint256'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'owner',
      'outputs': [
        {'internalType': 'address', 'name': '', 'type': 'address'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'owner', 'type': 'address'},
        {'internalType': 'address', 'name': 'spender', 'type': 'address'},
        {'internalType': 'uint256', 'name': 'value', 'type': 'uint256'},
        {'internalType': 'uint256', 'name': 'deadline', 'type': 'uint256'},
        {'internalType': 'uint8', 'name': 'v', 'type': 'uint8'},
        {'internalType': 'bytes32', 'name': 'r', 'type': 'bytes32'},
        {'internalType': 'bytes32', 'name': 's', 'type': 'bytes32'},
      ],
      'name': 'permit',
      'outputs': [],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'renounceOwnership',
      'outputs': [],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'symbol',
      'outputs': [
        {'internalType': 'string', 'name': '', 'type': 'string'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [],
      'name': 'totalSupply',
      'outputs': [
        {'internalType': 'uint256', 'name': '', 'type': 'uint256'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'recipient', 'type': 'address'},
        {'internalType': 'uint256', 'name': 'amount', 'type': 'uint256'},
      ],
      'name': 'transfer',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'sender', 'type': 'address'},
        {'internalType': 'address', 'name': 'recipient', 'type': 'address'},
        {'internalType': 'uint256', 'name': 'amount', 'type': 'uint256'},
      ],
      'name': 'transferFrom',
      'outputs': [
        {'internalType': 'bool', 'name': '', 'type': 'bool'},
      ],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
    {
      'inputs': [
        {'internalType': 'address', 'name': 'newOwner', 'type': 'address'},
      ],
      'name': 'transferOwnership',
      'outputs': [],
      'stateMutability': 'nonpayable',
      'type': 'function',
    },
  ];
}
