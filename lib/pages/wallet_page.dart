import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

import '../services/coin_service.dart';

class CoinProduct {
  final String productId;
  final int coins;
  final double price;
  final String priceText;

  const CoinProduct({
    required this.productId,
    required this.coins,
    required this.price,
    required this.priceText,
  });
}

const List<CoinProduct> kCoinProducts = [
  CoinProduct(productId: 'Zali', coins: 32, price: 0.99, priceText: '\$0.99'),
  CoinProduct(productId: 'Zali1', coins: 60, price: 1.99, priceText: '\$1.99'),
  CoinProduct(productId: 'Zali2', coins: 96, price: 2.99, priceText: '\$2.99'),
  CoinProduct(productId: 'Zali3', coins: 129, price: 3.99, priceText: '\$1.99'),
  CoinProduct(productId: 'Zali4', coins: 155, price: 4.99, priceText: '\$4.99'),
  CoinProduct(productId: 'Zali5', coins: 189, price: 5.99, priceText: '\$5.99'),
  CoinProduct(productId: 'Zali6', coins: 249, price: 6.99, priceText: '\$1.99'),
  CoinProduct(productId: 'Zali9', coins: 359, price: 9.99, priceText: '\$9.99'),
  CoinProduct(productId: 'Zali19', coins: 729, price: 19.99, priceText: '\$19.99'),
  CoinProduct(productId: 'Zali49', coins: 1869, price: 49.99, priceText: '\$49.99'),
  CoinProduct(productId: 'Zali99', coins: 3799, price: 99.99, priceText: '\$99.99'),
  CoinProduct(productId: 'Zali159', coins: 5999, price: 159.99, priceText: '\$159.99'),
  CoinProduct(productId: 'Zali239', coins: 9059, price: 239.99, priceText: '\$239.99'),
];

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Map<String, Timer> _timeoutTimers = {};
  final NumberFormat _coinsFormat = NumberFormat.decimalPattern();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Map<String, ProductDetails> _products = {};

  int _currentCoins = 0;
  int _selectedIndex = 0;
  bool _isPurchasing = false;
  bool _isAvailable = false;
  int _retryCount = 0;

  static const int _maxRetries = 3;
  static const int _timeoutDurationSeconds = 30;

  @override
  void initState() {
    super.initState();
    _initializeUserAndLoadCoins();
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

  Future<void> _initializeUserAndLoadCoins() async {
    await CoinService.initializeNewUser();
    await _loadCoins();
  }

  Future<void> _loadCoins() async {
    final coins = await CoinService.getCurrentCoins();
    if (!mounted) return;
    setState(() {
      _currentCoins = coins;
    });
  }

  Future<void> _checkConnectivityAndInit() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showToast('No internet connection. Please check your network.');
        return;
      }
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
    }
    await _initIAP();
  }

  Future<void> _initIAP() async {
    try {
      final available = await _inAppPurchase.isAvailable();
      if (!mounted) return;
      setState(() {
        _isAvailable = available;
      });
      if (!available) {
        _showToast('In-App Purchase not available.');
        return;
      }

      final ids = kCoinProducts.map((e) => e.productId).toSet();
      final response = await _inAppPurchase.queryProductDetails(ids);

      if (response.error != null) {
        if (_retryCount < _maxRetries) {
          _retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          await _initIAP();
          return;
        }
        _showToast('Failed to load products: ${response.error!.message}');
      }

      setState(() {
        _products = {for (final p in response.productDetails) p.id: p};
      });

      _subscription ??= _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (error) => _showToast('Purchase error: $error'),
        onDone: () => _subscription?.cancel(),
      );
    } catch (e) {
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 2));
        await _initIAP();
      } else {
        _showToast('Failed to initialize in-app purchases.');
      }
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _inAppPurchase.completePurchase(purchase);
          final product = kCoinProducts.firstWhere(
            (p) => p.productId == purchase.productID,
            orElse: () =>
                const CoinProduct(productId: '', coins: 0, price: 0, priceText: ''),
          );
          if (product.coins > 0) {
            final success = await CoinService.addCoins(product.coins);
            if (success) {
              await _loadCoins();
              _showToast('Successfully purchased ${product.coins} coins!');
            } else {
              _showToast('Failed to add coins. Please contact support.');
            }
          }
          break;
        case PurchaseStatus.error:
          _showToast('Purchase failed: ${purchase.error?.message ?? ''}');
          break;
        case PurchaseStatus.canceled:
          _showToast('Purchase canceled.');
          break;
        default:
          break;
      }
    }
    _clearPurchaseState();
  }

  void _clearPurchaseState() {
    if (!mounted) return;
    setState(() {
      _isPurchasing = false;
    });
    for (final timer in _timeoutTimers.values) {
      timer.cancel();
    }
    _timeoutTimers.clear();
  }

  Future<void> _handleConfirmPurchase() async {
    if (!_isAvailable) {
      _showToast('Store is not available.');
      return;
    }
    final selectedProduct = kCoinProducts[_selectedIndex];
    setState(() {
      _isPurchasing = true;
    });

    _timeoutTimers['purchase'] = Timer(
      const Duration(seconds: _timeoutDurationSeconds),
      _handlePurchaseTimeout,
    );

    try {
      ProductDetails? productDetails = _products[selectedProduct.productId];
      productDetails ??= _products.isNotEmpty ? _products.values.first : null;
      if (productDetails == null) {
        throw Exception('No products available for purchase.');
      }
      final param = PurchaseParam(productDetails: productDetails);
      await _inAppPurchase.buyConsumable(purchaseParam: param);
    } catch (e) {
      _timeoutTimers['purchase']?.cancel();
      _timeoutTimers.remove('purchase');
      _showToast('Purchase failed: $e');
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  void _handlePurchaseTimeout() {
    if (!mounted) return;
    setState(() {
      _isPurchasing = false;
    });
    _timeoutTimers['purchase']?.cancel();
    _timeoutTimers.remove('purchase');
    _showToast('Payment timeout. Please try again.');
  }

  void _showToast(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 36),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
                  .copyWith(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 137,
                    height: 137,
                    child: Image.asset(
                      'assets/wallet_bicycle.webp',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'My Coins',
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      _coinsFormat.format(_currentCoins),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: kCoinProducts.length,
                    itemBuilder: (context, index) =>
                        _buildProductCard(context, index),
                  ),
                ],
              ),
            ),
            if (_isPurchasing)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF28FF5E)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
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
        IconButton(
          onPressed: _showCoinInfoDialog,
          icon: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, int index) {
    final product = kCoinProducts[index];
    final isSelected = _selectedIndex == index;
    final priceLabel = _getPriceLabel(product);

    return GestureDetector(
      onTap: _isPurchasing
          ? null
          : () {
              HapticFeedback.lightImpact();
              _onProductSelected(index);
            },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF28FF5E) : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD66B),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.stars_rounded,
                color: Color(0xFF8C5C00),
                size: 28,
              ),
            ),
            Text(
              '${product.coins}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF28FF5E),
                borderRadius: BorderRadius.circular(40),
              ),
              alignment: Alignment.center,
              child: Text(
                priceLabel,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPriceLabel(CoinProduct product) {
    final productDetails = _products[product.productId];
    if (productDetails != null && productDetails.price.isNotEmpty) {
      return productDetails.price;
    }
    return product.priceText;
  }

  void _onProductSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final product = kCoinProducts[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C0325),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.diamond, color: Color(0xFFFFD700)),
            SizedBox(width: 8),
            Text(
              'Confirm Purchase',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          'Purchase ${product.coins} coins for ${_getPriceLabel(product)}?',
          style: const TextStyle(color: Color(0xFFCCCCCC)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF999999)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleConfirmPurchase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF80FED6),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Purchase',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showCoinInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.diamond, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Coin Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _CoinRule(number: '1', text: 'You can refresh the plan of the day for free three times a day. If you exceed this limit, you need to pay 200 Coins.'),
            SizedBox(height: 16),
            _CoinRule(number: '2', text: 'Unlock other people\'s gift ideas for 200 coins.'),
            SizedBox(height: 16),
            _CoinRule(number: '3', text: 'Coins are obtained via in-app purchases.'),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28FF5E),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Got it',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinRule extends StatelessWidget {
  const _CoinRule({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF28FF5E),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFCCCCCC),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

