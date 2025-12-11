import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Map orderConfirmation = {
      'orderId': orderId,
      'totalAmount': cart.totalPrice,
      'itemCount': cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
      Navigator.pop(context, orderConfirmation);
    }
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text('Checkout', style: heading1),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 4),
                    Text('${cart.countOfItems}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            List<Widget> columnChildren = [];

            columnChildren.add(const Text('Order Summary', style: heading2));
            columnChildren.add(const SizedBox(height: 20));

            for (MapEntry<Sandwich, int> entry in cart.items.entries) {
              final Sandwich sandwich = entry.key;
              final int quantity = entry.value;
              final double itemPrice = _calculateItemPrice(sandwich, quantity);

              final Widget itemRow = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${quantity}x ${sandwich.name}',
                    style: normalText,
                  ),
                  Text(
                    '£${itemPrice.toStringAsFixed(2)}',
                    style: normalText,
                  ),
                ],
              );

              columnChildren.add(itemRow);
              columnChildren.add(const SizedBox(height: 8));
            }

            columnChildren.add(const Divider());
            columnChildren.add(const SizedBox(height: 10));

            final Widget totalRow = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: heading2),
                Text(
                  '£${cart.totalPrice.toStringAsFixed(2)}',
                  style: heading2,
                ),
              ],
            );
            columnChildren.add(totalRow);
            columnChildren.add(const SizedBox(height: 40));

            columnChildren.add(
              const Text(
                'Payment Method: Card ending in 1234',
                style: normalText,
                textAlign: TextAlign.center,
              ),
            );
            columnChildren.add(const SizedBox(height: 20));

            if (_isProcessing) {
              columnChildren.add(
                const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              columnChildren.add(const SizedBox(height: 20));
              columnChildren.add(
                const Text(
                  'Processing payment...',
                  style: normalText,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              columnChildren.add(
                ElevatedButton(
                  onPressed: _processPayment,
                  child: const Text('Confirm Payment', style: normalText),
                ),
              );
            }

            return Column(
              children: columnChildren,
            );
          },
        ),
      ),
    );
  }
}