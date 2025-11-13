import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';

class NetworkSelectionModal extends StatefulWidget {
  final List<Map<String, dynamic>> initialSelected;

  const NetworkSelectionModal({super.key, required this.initialSelected});

  @override
  State<NetworkSelectionModal> createState() => _NetworkSelectionModalState();
}

class _NetworkSelectionModalState extends State<NetworkSelectionModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<bool> _defaultSelected;
  late List<bool> _customSelected;
  bool _isAllPopularNetworksSelected = false;

  final List<String> networks = [
    'Ethereum Mainnet',
    'Linea',
    'Base Mainnet',
    'BNB Smart Chain',
  ];

  // Show only Ethereum Mainnet and Sepolia
  final List<Map<String, dynamic>> defaultNetworks =
      kAvailableNetworks.where((token) => token["test"] == false).toList();
  final List<Map<String, dynamic>> customNetworks =
      kAvailableNetworks.where((token) => token["test"] == true).toList();

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

    // Check if all popular networks are selected initially
    _isAllPopularNetworksSelected = _defaultSelected.every(
      (element) => element,
    );
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
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Networks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Popular'), Tab(text: 'Custom')],
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // background color
                    foregroundColor: Colors.white, // text (and icon) color
                  ),
                  onPressed: () {
                    // Prepare the data to return to HomePage
                    final selectedNetworks = <Map<String, dynamic>>[];

                    // If "All popular networks" is selected, add all defaultNetworks
                    if (_isAllPopularNetworksSelected) {
                      selectedNetworks.addAll(defaultNetworks);
                    } else {
                      for (int i = 0; i < defaultNetworks.length; i++) {
                        if (_defaultSelected[i]) {
                          selectedNetworks.add(defaultNetworks[i]);
                        }
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

  Widget _buildNetworkList(
    List<bool> selectionList,
    List<Map<String, dynamic>> networks,
    int idx,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: idx == 0 ? networks.length + 1 : networks.length,
            itemBuilder: (bContext, index) {
              // Add "All popular networks" option at the top of Popular tab
              if (idx == 0 && index == 0) {
                return CheckboxListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 24.0,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'All popular networks',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  value: _isAllPopularNetworksSelected,
                  onChanged: (value) {
                    setState(() {
                      _isAllPopularNetworksSelected = value!;
                      // When "All popular networks" is selected, select all individual networks
                      if (value) {
                        for (int i = 0; i < _defaultSelected.length; i++) {
                          _defaultSelected[i] = true;
                        }
                      } else {
                        // When deselected, unselect all
                        for (int i = 0; i < _defaultSelected.length; i++) {
                          _defaultSelected[i] = false;
                        }
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }

              // Adjust index for network items (skip the "All popular networks" item)
              final networkIndex = idx == 0 ? index - 1 : index;

              return CheckboxListTile(
                title: Row(
                  children: [
                    AIImage(
                      networks[networkIndex]["icon"],
                      width: 24.0,
                      height: 24.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        networks[networkIndex]["displayName"].toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                value: selectionList[networkIndex],
                onChanged: (value) {
                  setState(() {
                    if (_tabController.index == 0) {
                      _defaultSelected[networkIndex] = value!;

                      // If any individual network is deselected, unselect "All popular networks"
                      if (!value) {
                        _isAllPopularNetworksSelected = false;
                      } else {
                        // Check if all are selected, then auto-select "All popular networks"
                        _isAllPopularNetworksSelected = _defaultSelected.every(
                          (element) => element,
                        );
                      }
                    } else {
                      _customSelected[networkIndex] = value!;
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
