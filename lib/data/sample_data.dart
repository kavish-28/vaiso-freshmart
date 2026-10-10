// For now, we hardcode the product list here.
// Later (Phase 2) this data + images will come from Firebase instead.
//
// imageUrl can be either:
//   - "assets/images/xxx.jpg"  -> a REAL photo bundled inside the app (fast, offline)
//   - "https://..."            -> a temporary internet placeholder (used until we
//                                  have the real photo for that item)
// The ProductImage widget (in product_image.dart) automatically picks the
// right way to load it - no other code needs to change as photos come in.

import '../models/product.dart';

List<Product> fishList = [
  Product(
    id: "fish_001",
    name: "Vanjaram",
    pricePerKg: 850,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/vanjaram.jpg",
  ),
  Product(
    id: "fish_002",
    name: "Sankara",
    pricePerKg: 450,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/sankara.jpg",
  ),
  Product(
    id: "fish_003",
    name: "Seela",
    pricePerKg: 600,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/seela.jpg",
  ),
  Product(
    id: "fish_004",
    name: "Mathi / Sardine",
    pricePerKg: 280,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/mathi.jpg",
  ),
  Product(
    id: "fish_005",
    name: "Ayala / Mackerel",
    pricePerKg: 350,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/ayala.jpg",
  ),
  Product(
    id: "fish_006",
    name: "Pomfret",
    pricePerKg: 750,
    isAvailable: false,
    category: "fish",
    imageUrl: "assets/images/pomfret.jpg",
  ),
  Product(
    id: "fish_007",
    name: "Rohu",
    pricePerKg: 350,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/rohu.jpg",
  ),
  Product(
    id: "fish_008",
    name: "Catla",
    pricePerKg: 400,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/catla.jpg",
  ),
  Product(
    id: "fish_009",
    name: "Tilapia",
    pricePerKg: 300,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/tilapia.jpg",
  ),
  Product(
    id: "fish_010",
    name: "Prawns",
    pricePerKg: 650,
    isAvailable: true,
    category: "fish",
    imageUrl: "assets/images/prawns.jpg",
  ),
  Product(
    id: "fish_011",
    name: "Crab",
    pricePerKg: 550,
    isAvailable: false,
    category: "fish",
    imageUrl: "assets/images/crab.jpg",
  ),
];

List<Product> chickenList = [
  Product(
    id: "chicken_001",
    name: "Broiler Chicken",
    pricePerKg: 220,
    isAvailable: true,
    category: "chicken",
    imageUrl: "assets/images/broiler_chicken.jpg",
  ),
  Product(
    id: "chicken_002",
    name: "Chicken Breast",
    pricePerKg: 320,
    isAvailable: true,
    category: "chicken",
    imageUrl: "assets/images/chicken_breast.jpg",
  ),
  Product(
    id: "chicken_003",
    name: "Chicken Leg",
    pricePerKg: 280,
    isAvailable: true,
    category: "chicken",
    imageUrl: "assets/images/chicken_leg.jpg",
  ),
  Product(
    id: "chicken_004",
    name: "Chicken Wings",
    pricePerKg: 260,
    isAvailable: true,
    category: "chicken",
    imageUrl: "assets/images/chicken_wings.jpg",
  ),
  Product(
    id: "chicken_005",
    name: "Chicken Liver",
    pricePerKg: 240,
    isAvailable: true,
    category: "chicken",
    imageUrl: "assets/images/chicken_liver.jpg",
  ),
  Product(
    id: "chicken_006",
    name: "Chicken Gizzard",
    pricePerKg: 250,
    isAvailable: false,
    category: "chicken",
    imageUrl: "assets/images/chicken_gizzard.png",
  ),
];
