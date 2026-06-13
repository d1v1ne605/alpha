import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';

final AssetOverview defaultValue = AssetOverview(
  totalAssets: "0",
  unit: "USDT",
  convertedValue: "0.0",
);

final AssetModel defaultAsset = AssetModel(
  id: "0",
  name: "-",
  symbol: "-",
  spot: 0.0,
  frozen: 0.0,
  currency: "-",
  iconUrl: "https://example.com/icon.png",
  price: 1.0,
  precision: 2,
  address: "0x0000000000000000000000000000000000000000",
);
