import 'package:flutter/material.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/injection_container.dart'; // Import your CacheHelper

// Address Entity Model
class AddressEntity {
  final String? id;
  final String houseNumber;
  final String landmark;
  final String city;
  final String district;
  final String state;
  final String pinCode;
  final bool isDefault;
  final bool isCachedLocation; // New field to identify cached location

  AddressEntity({
    this.id,
    required this.houseNumber,
    required this.landmark,
    required this.city,
    required this.district,
    required this.state,
    required this.pinCode,
    this.isDefault = false,
    this.isCachedLocation = false,
  });
}

class AddressesPage extends StatefulWidget {
  static const path = '/addresses';
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  List<AddressEntity> addresses = [];

  // Correct way to inject CacheHelper using your service locator
  late final CacheHelper _cacheHelper = sl<CacheHelper>();

  _AddressesPageState(); // Constructor should be empty if no params

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() async {
    // Load cached location first
    final cachedLocation = _loadCachedLocation();

    // Sample addresses - Replace with your actual data source
    final otherAddresses = [
      AddressEntity(
        id: '2',
        houseNumber: '123, Green Apartments',
        landmark: 'Near City Hospital',
        city: 'Mumbai',
        district: 'Mumbai Suburban',
        state: 'Maharashtra',
        pinCode: '400001',
        isDefault: cachedLocation == null, // Default if no cached location
      ),
      AddressEntity(
        id: '3',
        houseNumber: '456, Blue Villa',
        landmark: 'Opposite Park',
        city: 'Pune',
        district: 'Pune',
        state: 'Maharashtra',
        pinCode: '411001',
      ),
    ];

    // Combine cached location with other addresses
    if (cachedLocation != null) {
      addresses = [cachedLocation, ...otherAddresses];
    } else {
      addresses = otherAddresses;
    }
  }

  AddressEntity? _loadCachedLocation() {
    final locationDetails = _cacheHelper.getLocationDetails();
    final fullAddress = _cacheHelper.getFullAddress();
    final lat = _cacheHelper.getLatitude();
    final lng = _cacheHelper.getLongitude();

    if (locationDetails != null && fullAddress != null) {
      return AddressEntity(
        id: 'cached_location',
        houseNumber: fullAddress,
        landmark: lat != null && lng != null
            ? 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}'
            : 'Current Location',
        city: locationDetails['city'] ?? '',
        district: locationDetails['district'] ?? '',
        state: '', // Not cached, you may need to add state caching
        pinCode: '', // Not cached, you may need to add pincode caching
        isDefault: true,
        isCachedLocation: true,
      );
    }

    return null;
  }

  void _showAddAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddAddressBottomSheet(
        onAddressAdded: (address) {
          setState(() {
            addresses.add(address);
          });
        },
      ),
    );
  }

  void _deleteAddress(String? id) {
    // Prevent deletion of cached location
    if (id == 'cached_location') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete current location address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      addresses.removeWhere((addr) => addr.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address deleted successfully')),
    );
  }

  void _setDefaultAddress(String? id) {
    setState(() {
      addresses = addresses.map((addr) {
        return AddressEntity(
          id: addr.id,
          houseNumber: addr.houseNumber,
          landmark: addr.landmark,
          city: addr.city,
          district: addr.district,
          state: addr.state,
          pinCode: addr.pinCode,
          isDefault: addr.id == id,
          isCachedLocation: addr.isCachedLocation,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE0F4F6),
        foregroundColor: Colors.black,
        title: Text("My Addresses", style: AppTextStyles.w600(16)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: addresses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(addresses[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAddressSheet,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Address',
          style: AppTextStyles.w600(14).copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_rounded,
              size: 64,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 24),
          Text('No Addresses Added', style: AppTextStyles.w700(20)),
          const SizedBox(height: 8),
          Text(
            'Add your delivery address to place orders',
            style: AppTextStyles.w500(14).copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddAddressSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Add Address',
              style: AppTextStyles.w600(14).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressEntity address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: address.isDefault ? Colors.teal : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  address.isCachedLocation
                      ? Icons.my_location
                      : Icons.location_on,
                  color: Colors.teal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.isCachedLocation
                              ? 'Current Location'
                              : address.isDefault
                              ? 'Default Address'
                              : 'Address',
                          style: AppTextStyles.w600(
                            14,
                          ).copyWith(color: Colors.grey.shade900),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Default',
                              style: AppTextStyles.w600(
                                10,
                              ).copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (!address.isCachedLocation)
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                  itemBuilder: (context) => [
                    if (!address.isDefault)
                      PopupMenuItem(
                        onTap: () => _setDefaultAddress(address.id),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Set as Default',
                              style: AppTextStyles.w500(14),
                            ),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      onTap: () => _deleteAddress(address.id),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: AppTextStyles.w500(
                              14,
                            ).copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            address.houseNumber,
            style: AppTextStyles.w600(15).copyWith(color: Colors.grey.shade800),
          ),
          const SizedBox(height: 4),
          Text(
            address.landmark,
            style: AppTextStyles.w500(13).copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '${address.city}, ${address.district}',
            style: AppTextStyles.w500(13).copyWith(color: Colors.grey.shade600),
          ),
          if (address.state.isNotEmpty && address.pinCode.isNotEmpty)
            Text(
              '${address.state} - ${address.pinCode}',
              style: AppTextStyles.w500(
                13,
              ).copyWith(color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }
}

// ==================== ADD ADDRESS BOTTOM SHEET ====================

class _AddAddressBottomSheet extends StatefulWidget {
  final Function(AddressEntity) onAddressAdded;

  const _AddAddressBottomSheet({required this.onAddressAdded});

  @override
  State<_AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<_AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _houseNumberController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();

  bool _isDefault = false;

  @override
  void dispose() {
    _houseNumberController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final newAddress = AddressEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        houseNumber: _houseNumberController.text,
        landmark: _landmarkController.text,
        city: _cityController.text,
        district: _districtController.text,
        state: _stateController.text,
        pinCode: _pinCodeController.text,
        isDefault: _isDefault,
      );

      widget.onAddressAdded(newAddress);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_location_alt,
                        color: Colors.teal,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add New Address',
                      style: AppTextStyles.w700(
                        20,
                      ).copyWith(color: Colors.grey.shade900),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _houseNumberController,
                  label: 'House/Flat/Building',
                  hint: 'Enter house/flat/building number',
                  icon: Icons.home_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter house number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _landmarkController,
                  label: 'Landmark',
                  hint: 'Nearby landmark',
                  icon: Icons.location_searching,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter landmark';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cityController,
                        label: 'City',
                        hint: 'City name',
                        icon: Icons.location_city,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _districtController,
                        label: 'District',
                        hint: 'District name',
                        icon: Icons.map_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _stateController,
                        label: 'State',
                        hint: 'State name',
                        icon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _pinCodeController,
                        label: 'Pin Code',
                        hint: '000000',
                        icon: Icons.pin_drop_outlined,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length != 6) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value ?? false;
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                      Expanded(
                        child: Text(
                          'Set as default address',
                          style: AppTextStyles.w600(
                            14,
                          ).copyWith(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveAddress,
                    child: Text(
                      'Save Address',
                      style: AppTextStyles.w600(
                        16,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.w600(13).copyWith(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.w500(
              14,
            ).copyWith(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.teal, size: 20),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
