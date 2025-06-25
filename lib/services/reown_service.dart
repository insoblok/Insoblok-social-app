import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:reown_appkit/reown_appkit.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

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

// final kEthUnitInfor = [
//   {
//     'title': 'Wei',
//     'unit': EtherUnit.wei,
//     'desc': 'The smallest and atomic amount of Ether',
//   },
//   {'title': 'kwei', 'unit': EtherUnit.kwei, 'desc': 'Kwei, 1000 wei'},
//   {'title': 'mwei', 'unit': EtherUnit.mwei, 'desc': 'Mwei, one million wei'},
//   {
//     'title': 'gwei',
//     'unit': EtherUnit.gwei,
//     'desc':
//         'Gwei, one billion wei. Typically a reasonable unit to measure gas prices.',
//   },
//   {
//     'title': 'szabo',
//     'unit': EtherUnit.szabo,
//     'desc': 'Szabo, 10^12 wei or 1 μEther',
//   },
//   {
//     'title': 'finney',
//     'unit': EtherUnit.finney,
//     'desc': 'Finney, 10^15 wei or 1 mEther',
//   },
//   {'title': 'ether', 'unit': EtherUnit.ether, 'desc': '1 Ether'},
// ];

// class EthTransferRequest {
//   String? recipientAddress;
//   int? amount;
//   EtherUnit? unit;

//   EthTransferRequest({this.recipientAddress, this.amount, this.unit});
// }

class ReownService {
  // late ReownAppKitModal _appKitModel;
  // ReownAppKitModal get appKitModel => _appKitModel;

  Future<void> init(BuildContext context) async {
    // _appKitModel = ReownAppKitModal(
    //   context: context,
    //   projectId: kReownProjectID,
    //   metadata: const PairingMetadata(
    //     name: 'insoblokai',
    //     description: 'insoblokai.io',
    //     url: 'https://www.insoblokai.io/',
    //     icons: [
    //       'https://firebasestorage.googleapis.com/v0/b/insoblokai.firebasestorage.app/o/ic_inso.png?alt=media&token=78ee384d-c7c3-4d8f-b7c1-5fcecbe0e202',
    //     ],
    //     redirect: Redirect(
    //       native: 'insoblokai://',
    //       universal: 'https://www.insoblokai.io/insoblokai',
    //       linkMode: false,
    //     ),
    //   ),
    // );

    // await _appKitModel.init();
    // DeepLinkHandler.init(_appKitModel);
  }

  Future<void> connect() async {
    if (!isConnected) {
      // await _appKitModel.openModalView(ReownAppKitModalMainWalletsPage());
    }
  }

  // bool get isConnected => appKitModel.isConnected;
  bool get isConnected => true;

  // String? get chainID => appKitModel.selectedChain?.chainId;
  // String? get namespace =>
  //     chainID == null ? null : NamespaceUtils.getNamespaceFromChain(chainID!);

  // String? get walletAddress =>
  //     namespace == null ? null : appKitModel.session?.getAddress(namespace!);
  String? get walletAddress => '0xffffffffffffffffffffffffffffffffffffffff';

  // DeployedContract? get deployedContract =>
  //     walletAddress == null
  //         ? null
  //         : DeployedContract(
  //           ContractAbi.fromJson(jsonEncode(contractABI), namespace ?? 'ETH'),
  //           EthereumAddress.fromHex(walletAddress!),
  //         );

  // Future<List<dynamic>> get balanceOf => appKitModel.requestReadContract(
  //   deployedContract: deployedContract!,
  //   topic: appKitModel.session!.topic,
  //   chainId: chainID!,
  //   functionName: 'balanceOf',
  //   parameters: [EthereumAddress.fromHex(walletAddress!)],
  // );

  // Future<List<dynamic>> get totalSupply => appKitModel.requestReadContract(
  //   deployedContract: deployedContract!,
  //   topic: appKitModel.session!.topic,
  //   chainId: appKitModel.selectedChain!.chainId,
  //   functionName: 'totalSupply',
  // );

  // Future<EthTransferRequest?> onShowTransferModal(
  //   BuildContext context, {
  //   String? address,
  // }) async {
  //   List<UserModel?> allUsers = [];
  //   if (address == null) {
  //     allUsers.addAll(await UserService().getAllUsers());
  //   }

  //   return showModalBottomSheet<EthTransferRequest>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       var result = EthTransferRequest(
  //         recipientAddress: address,
  //         unit: EtherUnit.wei,
  //         amount: 1,
  //       );
  //       var userNotifier = ValueNotifier<UserModel?>(
  //         allUsers.isNotEmpty ? allUsers.first : null,
  //       );
  //       var unitNotifier = ValueNotifier(kEthUnitInfor.first);
  //       var amountNotifier = ValueNotifier(1);
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).scaffoldBackgroundColor,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(24.0),
  //             topRight: Radius.circular(24.0),
  //           ),
  //         ),
  //         padding: EdgeInsets.only(
  //           left: 20.0,
  //           right: 20.0,
  //           top: 24.0,
  //           bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: Column(
  //           spacing: 24.0,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Etherium', style: Theme.of(context).textTheme.titleSmall),
  //             if (address == null)
  //               ValueListenableBuilder<UserModel?>(
  //                 valueListenable: userNotifier,
  //                 builder: (context, value, _) {
  //                   return Column(
  //                     spacing: 12.0,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('Wallet Address'),
  //                       Container(
  //                         decoration: kNoBorderDecoration,
  //                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                         child: DropdownButton<UserModel>(
  //                           isExpanded: true,
  //                           value: value,
  //                           dropdownColor:
  //                               Theme.of(context).colorScheme.onSecondary,
  //                           icon: const Icon(Icons.keyboard_arrow_down),
  //                           underline: Container(),
  //                           items:
  //                               allUsers.map((user) {
  //                                 return DropdownMenuItem(
  //                                   value: user,
  //                                   child: Text(
  //                                     user!.fullName,
  //                                     style:
  //                                         Theme.of(context).textTheme.bodySmall,
  //                                   ),
  //                                 );
  //                               }).toList(),
  //                           onChanged: (value) {
  //                             userNotifier.value = value;
  //                             result.recipientAddress = value?.walletAddress;
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ValueListenableBuilder<dynamic>(
  //               valueListenable: unitNotifier,
  //               builder: (context, value, _) {
  //                 return Column(
  //                   spacing: 12.0,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Etherium Unit'),
  //                     Container(
  //                       decoration: kNoBorderDecoration,
  //                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                       child: DropdownButton<dynamic>(
  //                         isExpanded: true,
  //                         value: value,
  //                         dropdownColor:
  //                             Theme.of(context).colorScheme.onSecondary,
  //                         icon: const Icon(Icons.keyboard_arrow_down),
  //                         underline: Container(),
  //                         items:
  //                             kEthUnitInfor.map((ethInfo) {
  //                               return DropdownMenuItem(
  //                                 value: ethInfo,
  //                                 child: Text(
  //                                   (ethInfo['title'] as String).toUpperCase(),
  //                                   style:
  //                                       Theme.of(context).textTheme.bodySmall,
  //                                 ),
  //                               );
  //                             }).toList(),
  //                         onChanged: (value) {
  //                           unitNotifier.value = value;
  //                           result.unit = value['unit'];
  //                         },
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 12.0),
  //                       child: Text(
  //                         value['desc'],
  //                         style: Theme.of(context).textTheme.labelLarge,
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //             ValueListenableBuilder(
  //               valueListenable: amountNotifier,
  //               builder: (context, value, _) {
  //                 return Column(
  //                   spacing: 12.0,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Transfer Amount'),
  //                     Container(
  //                       width: double.infinity,
  //                       decoration: kNoBorderDecoration,
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 20.0,
  //                         vertical: 12.0,
  //                       ),
  //                       alignment: Alignment.center,
  //                       child: Text(value.toString()),
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         InkWell(
  //                           onTap: () {
  //                             var updated = value - 100;
  //                             if (updated < 1) {
  //                               updated = 1;
  //                             }
  //                             amountNotifier.value = updated;
  //                             result.amount = updated;
  //                           },
  //                           child: Text('-100'),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             var updated = value - 10;
  //                             if (updated < 1) {
  //                               updated = 1;
  //                             }
  //                             amountNotifier.value = updated;
  //                             result.amount = updated;
  //                           },
  //                           child: Text('-10'),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             var updated = value - 1;
  //                             if (updated < 1) {
  //                               updated = 1;
  //                             }
  //                             amountNotifier.value = updated;
  //                             result.amount = updated;
  //                           },
  //                           child: Text('-1'),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             result.amount = value + 1;
  //                             amountNotifier.value = value + 1;
  //                           },
  //                           child: Text('+1'),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             result.amount = value + 10;
  //                             amountNotifier.value = value + 10;
  //                           },
  //                           child: Text('+10'),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             result.amount = value + 100;
  //                             amountNotifier.value = value + 100;
  //                           },
  //                           child: Text('+100'),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //             Row(
  //               spacing: 24.0,
  //               children: [
  //                 Expanded(
  //                   child: TextFillButton(
  //                     text: "Send",
  //                     color: AIColors.pink,
  //                     onTap: () => Navigator.of(context).pop(result),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: OutlineButton(
  //                     onTap: () => Navigator.of(context).pop(),
  //                     child: Text('Cancel'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<dynamic> ethSendTransaction({required EthTransferRequest req}) async {
  //   return await _appKitModel.request(
  //     topic: _appKitModel.session!.topic,
  //     chainId: _appKitModel.selectedChain!.chainId,
  //     request: SessionRequestParams(
  //       method: SupportedMethods.ethSendTransaction.name,
  //       params: [
  //         Transaction(
  //           from: EthereumAddress.fromHex(walletAddress ?? ''),
  //           to: EthereumAddress.fromHex(req.recipientAddress!),
  //           value: EtherAmount.fromInt(req.unit!, req.amount!),
  //           data: utf8.encode('0x'),
  //         ).toJson(),
  //       ],
  //     ),
  //   );
  // }

  String typedData =
      r'''{"types":{"EIP712Domain":[{"type":"string","name":"name"},{"type":"string","name":"version"},{"type":"uint256","name":"chainId"},{"type":"address","name":"verifyingContract"}],"Part":[{"name":"account","type":"address"},{"name":"value","type":"uint96"}],"Mint721":[{"name":"tokenId","type":"uint256"},{"name":"tokenURI","type":"string"},{"name":"creators","type":"Part[]"},{"name":"royalties","type":"Part[]"}]},"domain":{"name":"Mint721","version":"1","chainId":4,"verifyingContract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce"},"primaryType":"Mint721","message":{"@type":"ERC721","contract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce","tokenId":"1","uri":"ipfs://ipfs/hash","creators":[{"account":"0xc5eac3488524d577a1495492599e8013b1f91efa","value":10000}],"royalties":[],"tokenURI":"ipfs://ipfs/hash"}}''';

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
