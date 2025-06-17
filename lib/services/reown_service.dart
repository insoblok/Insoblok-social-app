import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:reown_appkit/reown_appkit.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media',
          // 'https://imagedelivery.net/_aTEfDRm7z3tKgu9JhfeKA/66fc1a08-80b1-4867-3563-33a8d803f200/lg',
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
  // bool get isConnected => true;

  String? get chainID => appKitModel.selectedChain?.chainId;
  String? get namespace =>
      chainID == null ? null : NamespaceUtils.getNamespaceFromChain(chainID!);
  String? get walletAddress =>
      namespace == null ? null : appKitModel.session?.getAddress(namespace!);
  // String? get walletAddress => '0xffffffffffffffffffffffffffffffffffffffff';

  DeployedContract? get deployedContract =>
      walletAddress == null
          ? null
          : DeployedContract(
            ContractAbi.fromJson(
              jsonEncode(contractABI), // ABI object
              'Tether USD',
            ),
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

  Future<void> transferToken(String recipientAddress) async {
    if (!appKitModel.isConnected) return;

    if (deployedContract == null) return;

    final decimals = await appKitModel.requestReadContract(
      topic: appKitModel.session!.topic,
      chainId: chainID!,
      deployedContract: deployedContract!,
      functionName: 'decimals',
    );
    final decimalUnits = (decimals.first as BigInt);
    final transferValue = _formatValue(
      0.1,
      decimals: decimalUnits,
    ); // your format value function

    final result = await appKitModel.requestWriteContract(
      topic: appKitModel.session!.topic,
      chainId: chainID!,
      deployedContract: deployedContract!,
      functionName: 'transfer',
      transaction: Transaction(from: EthereumAddress.fromHex(walletAddress!)),
      parameters: [EthereumAddress.fromHex(recipientAddress), transferValue],
    );

    logger.d(result);
  }

  BigInt _formatValue(num value, {required BigInt decimals}) {
    final multiplier = _multiplier(decimals);
    final result = EtherAmount.fromInt(
      EtherUnit.ether,
      (value * multiplier).toInt(),
    );
    return result.getInEther;
  }

  int _multiplier(BigInt decimals) {
    final d = decimals.toInt();
    final pad = '1'.padRight(d + 1, '0');
    return int.parse(pad);
  }

  Future<bool?> showWallet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            color: AIColors.darkScaffoldBackground,
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Do you want to connect your wallet to INSOBLOK?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AIColors.pink,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.pink,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.pink,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
