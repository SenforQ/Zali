import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/vip_subscription.dart';
import '../services/vip_service.dart';
import '../services/vip_subscription_service.dart';

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  VipSubscription? _selectedSubscription;
  List<VipSubscription> _subscriptions = VipSubscriptionService.getSubscriptions();
  final List<VipPrivilege> _privileges = VipSubscriptionService.getPrivileges();

  bool _isVipActive = false;
  int _retryCount = 0;
  static const int maxRetries = 3;
  static const int timeoutDuration = 30;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;
  Map<String, ProductDetails> _products = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, Timer> _timeoutTimers = {};

  @override
  void initState() {
    super.initState();
    _selectedSubscription = _subscriptions.firstWhere(
      (sub) => sub.isMostPopular,
      orElse: () => _subscriptions.first,
    );
    _loadVipStatus();
    _checkConnectivityAndInit();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    for (final timer in _timeoutTimers.values) {
      timer.cancel();
    }
    _timeoutTimers.clear();
    super.dispose();
  }

  void _selectSubscription(VipSubscription subscription) {
    setState(() {
      _selectedSubscription = subscription;
    });
  }

  Future<void> _loadVipStatus() async {
    try {
      final isActive = await VipService.isVipActive();
      final isExpired = await VipService.isVipExpired();

      setState(() {
        _isVipActive = isActive && !isExpired;
      });

      if (isActive && isExpired) {
        await VipService.deactivateVip();
        setState(() {
          _isVipActive = false;
        });
      }
    } catch (e) {
      debugPrint('VipPage - Error loading VIP status: $e');
    }
  }

  Future<void> _checkConnectivityAndInit() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none)) {
        _showToast('No internet connection. Please check your network settings.');
        return;
      }
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
    }
    await _initIAP();
  }

  Future<void> _initIAP() async {
    try {
      _updateProductPrices();

      final available = await _inAppPurchase.isAvailable();
      if (!mounted) return;
      setState(() {
        _isAvailable = available;
      });
      if (!available) {
        if (mounted) {
          _showToast('In-App Purchase not available');
        }
        return;
      }

      final Set<String> kIds = _subscriptions.map((e) => e.productId).toSet();
      final response = await _inAppPurchase.queryProductDetails(kIds);

      if (response.error != null) {
        if (_retryCount < maxRetries) {
          _retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          await _initIAP();
          return;
        }
        _showToast('Failed to load products: ${response.error!.message}');
        return;
      }

      setState(() {
        _products = {for (var p in response.productDetails) p.id: p};
      });

      _updateProductPrices();

      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () {
          _subscription?.cancel();
        },
        onError: (e) {
          if (mounted) {
            _showToast('Purchase error: ${e.toString()}');
          }
        },
      );
    } catch (e) {
      if (_retryCount < maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 2));
        await _initIAP();
      } else {
        if (mounted) {
          _showToast('Failed to initialize in-app purchases. Please try again later.');
        }
      }
    }
  }

  void _updateProductPrices() {
    setState(() {
      _subscriptions = _subscriptions
          .map((product) => product.copyWith(isPriceLoaded: true))
          .toList();
    });
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _inAppPurchase.completePurchase(purchase);

        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          final validProductIds =
              _subscriptions.map((s) => s.productId).toSet();

          if (validProductIds.contains(purchase.productID)) {
            try {
              final durationDays = purchase.productID == 'ZaliVIP7' ? 7 : 30;
              await VipService.activateVip(
                productId: purchase.productID,
                purchaseDate: DateTime.now().toIso8601String(),
                durationDays: durationDays,
              );

              if (mounted) {
                setState(() {
                  _isVipActive = true;
                });
                _showVipStatusDialog();
              }
            } catch (e) {
              debugPrint('VipPage - Error activating VIP: $e');
              if (mounted) {
                _showToast('Failed to activate VIP. Please contact support.');
              }
            }
          } else {
            if (mounted) {
              _showToast('Invalid product. Please try again.');
            }
          }
        }
      } else if (purchase.status == PurchaseStatus.error) {
        if (mounted) {
          _showToast('Purchase failed: ${purchase.error?.message ?? ''}');
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        if (mounted) {
          _showToast('Purchase canceled.');
        }
      }

      if (mounted) {
        setState(() {
          _loadingStates.clear();
        });
        for (final timer in _timeoutTimers.values) {
          timer.cancel();
        }
        _timeoutTimers.clear();
      }
    }
  }

  void _handleTimeout(String productId) {
    if (mounted) {
      setState(() {
        _loadingStates[productId] = false;
      });

      _timeoutTimers[productId]?.cancel();
      _timeoutTimers.remove(productId);

      _showToast('Payment timeout. Please try again.');
    }
  }

  void _confirmSubscription() {
    if (_selectedSubscription == null) return;

    if (!_isAvailable) {
      _showToast('Store is not available');
      return;
    }

    if (_isVipActive) {
      _showToast('You already have an active VIP subscription');
      return;
    }

    _handleConfirmPurchase();
  }

  Future<void> _handleConfirmPurchase() async {
    if (_selectedSubscription == null) return;

    final validProductIds = _subscriptions.map((s) => s.productId).toSet();
    if (!validProductIds.contains(_selectedSubscription!.productId)) {
      _showToast('Invalid subscription selected. Please try again.');
      return;
    }

    setState(() {
      _loadingStates[_selectedSubscription!.productId] = true;
    });

    _timeoutTimers[_selectedSubscription!.productId] = Timer(
      const Duration(seconds: timeoutDuration),
      () => _handleTimeout(_selectedSubscription!.productId),
    );

    try {
      final product = _products[_selectedSubscription!.productId];

      if (product == null) {
        throw Exception('Selected product not available for purchase');
      }

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _timeoutTimers[_selectedSubscription!.productId]?.cancel();
      _timeoutTimers.remove(_selectedSubscription!.productId);

      if (mounted) {
        _showToast('Purchase failed: ${e.toString()}');
      }
      setState(() {
        _loadingStates[_selectedSubscription!.productId] = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    if (!_isAvailable) {
      _showToast('Store is not available');
      return;
    }
    try {
      await _inAppPurchase.restorePurchases();
      _showToast('Restoring purchases...');
    } catch (e) {
      if (mounted) {
        _showToast('Restore failed: ${e.toString()}');
      }
    }
  }

  String _getPriceText(VipSubscription subscription) {
    final productDetails = _products[subscription.productId];
    if (productDetails != null && productDetails.price.isNotEmpty) {
      return productDetails.price;
    }
    return '${subscription.currency}${subscription.price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.black,
            child: Image.asset(
              'assets/mine_top_bg.webp',
              fit: BoxFit.cover,
              width: screenWidth,
              height: screenHeight,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.black,
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF141414),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const Text(
                        'VIP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Member Benefits',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ..._privileges.asMap().entries.map((entry) {
                          final index = entry.key;
                          final privilege = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index < _privileges.length - 1 ? 20 : 0,
                            ),
                            child: _buildBenefitItem(privilege.title),
                          );
                        }),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: _subscriptions.map((subscription) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: subscription != _subscriptions.last
                                      ? 16
                                      : 0,
                                ),
                                child: _buildSubscriptionCard(subscription),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _isVipActive ? null : _confirmSubscription,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF28FF5E),
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.grey,
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            _isVipActive ? 'VIP Active' : 'Confirm',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_loadingStates.values.any((loading) => loading))
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF28FF5E)),
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF28FF5E),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF28FF5E),
                width: 2,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF1A7A3A),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(VipSubscription subscription) {
    final bool isSelected = _selectedSubscription?.id == subscription.id;
    final bool isLoading = _loadingStates[subscription.productId] ?? false;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              _selectSubscription(subscription);
              HapticFeedback.lightImpact();
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF28FF5E)
                : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPriceText(subscription),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF28FF5E)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF28FF5E)
                      : const Color(0xFF999999),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showVipStatusDialog() async {
    if (!mounted) return;

    final int remainingDays = await VipService.getVipRemainingDays();
    final String? purchaseDate = await VipService.getVipPurchaseDate();

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C0325),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF28FF5E), Color(0xFF1A7A3A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.diamond,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'VIP Activated!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF28FF5E).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF28FF5E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Remaining Days:',
                          style: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$remainingDays days',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (purchaseDate != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Activated:',
                            style: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _formatDate(purchaseDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You now have access to all VIP features!',
                style: TextStyle(
                  color: Color(0xFF28FF5E),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28FF5E),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showToast(String message) {
    if (mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (BuildContext context) => Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
