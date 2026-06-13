import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';

mixin OrderFormManager on BaseViewModel {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController orderValueController = TextEditingController();
  final TextEditingController priceOfCoinController = TextEditingController();

  final ValueNotifier<OrderTypeEnum?> _orderFormType = ValueNotifier(
    OrderTypeEnum.buy,
  );

  ValueNotifier<OrderTypeEnum?> get orderFormType => _orderFormType;

  double _availableQuoteBalance = 0.0;

  double get availableQuoteBalance => _availableQuoteBalance;

  set availableQuoteBalance(double value) {
    if (_availableQuoteBalance != value && value >= 0) {
      _availableQuoteBalance = value;
    }
  }

  double _availableCoin = 0.0;

  double get availableCoin => _availableCoin;

  set availableCoin(double value) {
    if (_availableCoin != value && value >= 0) {
      _availableCoin = value;
    }
  }

  double _quantity = 0;

  double get quantity => _quantity;

  set quantity(double value) {
    if (_quantity != value && value >= 0) {
      _quantity = value;
    }
  }

  double _priceOfCoin = 0.0;

  double get priceOfCoin => _priceOfCoin;

  set priceOfCoin(double value) {
    if (_priceOfCoin != value && value >= 0) {
      _priceOfCoin = value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final fractionalDigits = _priceOfCoin.currentFractionalDigits;
        priceOfCoinController.text = _priceOfCoin == _priceOfCoin.toInt()
            ? _priceOfCoin.toInt().toString()
            : _priceOfCoin.truncateToDecimalPlaces(fractionalDigits).toString();
      });
    }
  }

  double _sliderPercent = 0.0;

  double get sliderPercent => _sliderPercent;

  set sliderPercent(double value) {
    if (_sliderPercent != value && value >= 0 && value <= 1) {
      _sliderPercent = value;
      notifyListeners();
    }
  }

  int _pricePrecision = 4;

  int get pricePrecision => _pricePrecision;

  set pricePrecision(int value) {
    if (_pricePrecision != value && value > 0) {
      _pricePrecision = value;
    }
  }

  int _quantityPrecision = 6;

  int get quantityPrecision => _quantityPrecision;

  set quantityPrecision(int value) {
    if (_quantityPrecision != value && value > 0) {
      _quantityPrecision = value;
    }
  }

  double get maxBuy {
    if (priceOfCoin > 0) {
      return orderFormType.value == OrderTypeEnum.buy
          ? availableQuoteBalance / priceOfCoin
          : availableCoin;
    }
    return 0;
  }

  String _selectedOrderType = '';

  void initializeSelectedOrderType(BuildContext context) {
    if (_selectedOrderType.isEmpty) {
      _selectedOrderType = context.appLocaleLanguage.limit;
    } else {
      if (_selectedOrderType == context.appLocaleLanguage.market) {
        _selectedOrderType = context.appLocaleLanguage.market;
      } else {
        _selectedOrderType = context.appLocaleLanguage.limit;
      }
      notifyListeners();
    }
  }

  List<String> get options => [
    context!.appLocaleLanguage.limit,
    context!.appLocaleLanguage.market,
  ];

  String get selectedOrderType => _selectedOrderType;

  set selectedOrderType(String value) {
    if (_selectedOrderType != value && options.contains(value)) {
      _selectedOrderType = value;
    }
  }

  bool get isLimitOrder =>
      _selectedOrderType == context?.appLocaleLanguage.limit;

  double get orderValue {
    final quantityDecimal = Decimal.parse(FormatterUtils.formatPrice(quantity));
    final price = isLimitOrder
        ? Decimal.parse(FormatterUtils.formatPrice(priceOfCoin))
        : Decimal.parse(FormatterUtils.formatPrice(_lastPrice));

    final result = quantityDecimal * price;
    return result.toDouble();
  }

  String get orderTypeKey {
    if (selectedOrderType == context?.appLocaleLanguage.limit) {
      return AppStorageKey.orderLimitType;
    } else {
      return AppStorageKey.orderMarketType;
    }
  }

  int get orderValuePrecision => 6;

  double _lastPrice = 0.0;

  double get lastPrice => _lastPrice;

  set lastPrice(double value) {
    if (_lastPrice != value && value >= 0) {
      _lastPrice = value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        priceOfCoinController.text = FormatterUtils.formatPrice(_lastPrice);
      });
    }
  }

  void updateOrderValueWhenChangeMarketType() {
    if (isLimitOrder && priceOfCoin > 0) {
      orderValueController.text = orderValue == 0
          ? ''
          : FormatterUtils.formatPrice(
              orderValue.truncateToDecimalPlaces(orderValuePrecision),
            );
    } else {
      if (quantityController.text.isEmpty) {
        orderValueController.clear();
      } else {
        orderValueController.text = lastPrice == 0
            ? ''
            : FormatterUtils.formatPrice(
                (lastPrice * quantity).truncateToDecimalPlaces(
                  orderValuePrecision,
                ),
              );
      }
    }
  }

  void updateOrder({
    required String value,
    required UpdateOrderTradeEnum type,
  }) {
    final parsed = double.tryParse(value);
    final safeParsed = (parsed != null && parsed >= 0) ? parsed : 0.0;

    switch (type) {
      case UpdateOrderTradeEnum.quantity:
        _updateByQuantity(safeParsed);
        break;
      case UpdateOrderTradeEnum.orderValue:
        _updateByOrderValue(safeParsed);
        break;
      case UpdateOrderTradeEnum.slider:
        _updateBySlider(safeParsed);
        break;
      case UpdateOrderTradeEnum.priceOfCoin:
        _updateByPriceOfCoin(safeParsed);
    }
  }

  void _updateByQuantity(double qty) {
    if (qty != _quantity) {
      _quantity = qty;
      orderValueController.text = FormatterUtils.formatPrice(
        orderValue.truncateToDecimalPlaces(orderValuePrecision),
      );
    }
  }

  void _updateByOrderValue(double value) {
    final qty = _priceOfCoin > 0 ? value / _priceOfCoin : 0;
    if (qty != _quantity) {
      _quantity = qty.toDouble();
      quantityController.text = _quantity == 0
          ? ''
          : FormatterUtils.formatPrice(
              _quantity.truncateToDecimalPlaces(_quantityPrecision),
            );
    }
  }

  void _updateBySlider(double percent) {
    if (percent == 0 ||
        percent == 0.25 ||
        percent == 0.5 ||
        percent == 0.75 ||
        percent == 1) {
      quantity = maxBuy * percent;
      quantityController.text = _quantity == 0
          ? ''
          : FormatterUtils.formatPrice(
              _quantity.truncateToDecimalPlaces(_quantityPrecision),
            );
      orderValueController.text = orderValue == 0
          ? ''
          : FormatterUtils.formatPrice(
              orderValue.truncateToDecimalPlaces(orderValuePrecision),
            );
      sliderPercent = percent.clamp(0, 1);
    }
  }

  void _updateByPriceOfCoin(double price) {
    if (price != _priceOfCoin) {
      _priceOfCoin = price;
      orderValueController.text = orderValue == 0
          ? ''
          : FormatterUtils.formatPrice(
              orderValue.truncateToDecimalPlaces(orderValuePrecision),
            );
    }
  }

  String? validateOrder() {
    if (_priceOfCoin <= 0) {
      return context?.appLocaleLanguage.priceOfCoinMustBeGreaterThanZero;
    }
    if (_quantity <= 0) {
      return context?.appLocaleLanguage.quantityMustBeGreaterThanZero;
    }
    if (orderValue < 1) {
      return context?.appLocaleLanguage.orderValueMustBeGreaterThanOrEqualToOne;
    }
    if (sliderPercent < 0 || sliderPercent > 1) {
      return context?.appLocaleLanguage.percentageMustBeValid;
    }
    if (_quantity > maxBuy) {
      return context?.appLocaleLanguage.quantityExceedsAvailableBalance;
    }
    if (_orderFormType.value == OrderTypeEnum.buy &&
        orderValue > _availableQuoteBalance) {
      return context?.appLocaleLanguage.orderValueExceedsAvailableBalance;
    }
    return null;
  }

  void orderFormTypeDispose() {
    quantityController.dispose();
    orderValueController.dispose();
    priceOfCoinController.dispose();
    _orderFormType.dispose();
  }
}
