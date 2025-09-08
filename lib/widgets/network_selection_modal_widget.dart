import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';

class NetworkSelectionModal extends StatefulWidget {
  final List<Map<String, dynamic>> initialSelected;

  const NetworkSelectionModal({
    super.key,
    required this.initialSelected,
  });

  @override
  State<NetworkSelectionModal> createState() => _NetworkSelectionModalState();
}

class _NetworkSelectionModalState extends State<NetworkSelectionModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<bool> _defaultSelected;
  late List<bool> _customSelected;
  final List<bool> _selectAll = [false, false];
  
  final List<String> networks = [
    'Ethereum Mainnet',
    'Linea',
    'Base Mainnet',
    'BNB Smart Chain',
  ];

  final List<Map<String, dynamic>> defaultNetworks = kWalletTokenList.where((token) => token["test"] == false).toList();
  final List<Map<String, dynamic>> customNetworks = kWalletTokenList.where((token) => token["test"] == true).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize state based on the values passed from HomePage
    
    // Convert the list of selected network names to checkbox states
    _defaultSelected = List.generate(defaultNetworks.length, (index) {
      return widget.initialSelected.contains(defaultNetworks[index]);
    });
    
    _customSelected = List.generate(customNetworks.length, (index) {
      return widget.initialSelected.contains(customNetworks[index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext bContext) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Networks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Default'),
              Tab(text: 'Custom'),
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNetworkList(_defaultSelected, defaultNetworks, 0),
                _buildNetworkList(_customSelected, customNetworks, 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(bContext),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Prepare the data to return to HomePage
                    final selectedNetworks = <Map<String, dynamic>>[];
                    for (int i = 0; i < defaultNetworks.length; i++) {
                      if (_defaultSelected[i]) {
                        selectedNetworks.add(defaultNetworks[i]);
                      }
                    }
                    for (int i = 0; i < customNetworks.length; i++) {
                      if (_customSelected[i]) {
                        selectedNetworks.add(customNetworks[i]);
                      }
                    }
                    
                    // Return the state to HomePage
                    Navigator.pop(bContext, {
                      'enabledNetworks': selectedNetworks,
                    });
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkList(List<bool> selectionList, List<Map<String, dynamic>> networks, int idx) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _selectAll[idx],
              onChanged: (value) {
                setState(() {
                  _selectAll[idx] = value!;
                  if(_tabController.index == 0) {
                    for (int i = 0; i < networks.length; i++) {
                      _defaultSelected[i] = value;

                    }
                  }
                  else if (_tabController.index == 1) {
                    for (int i = 0; i < networks.length; i++) {
                      _customSelected[i] = value;
                    }
                  }
                });
              },
            ),
            const Text('Select all'),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: networks.length,
            itemBuilder: (bContext, index) {
              return CheckboxListTile(
                title: Row(
                  children: [
                    AIImage(networks[index]["icon"], width: 24.0, height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(networks[index]["displayName"].toString(), style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
                value: selectionList[index],
                onChanged: (value) {
                  setState(() {
                    if (_tabController.index == 0) {
                      _defaultSelected[index] = value!;
                      
                      // Update select all checkbox if needed
                      if (!value) {
                        _selectAll[idx] = false;
                      } else {
                        // Check if all are selected
                        _selectAll[idx] = _defaultSelected.every((element) => element);
                      }
                    } else {
                      _customSelected[index] = value!;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        ),
      ],
    );
  }
}