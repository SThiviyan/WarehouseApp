//
//  Product.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 11.03.25.
//
import UIKit


struct Product: Codable {
    private var barcode: String?
    private var productname: String
    private var producer: String?
    
    private var price: Double?
    private var currency: String?
    
    private var size: Double?
    private var unit: String?
    
    private var category: [String]?
    
    //UIIMAGE does not conform to codable, there is a better solution to this!
    private var image: Data?
    
    // Initializer mit zusätzlichen Parametern und Default-Werten für optionale Eigenschaften
    init(productname: String,
         price: Double,
         currency: String? = "EUR",
         size: Double,
         unit: String? = "g",   // z. B. "g" oder "ml"
         category: [String],
         image: UIImage,
         producer: String,
         barcode: String? = nil) {
        
        self.productname = productname
        self.price = price
        self.currency = currency
        self.size = size
        self.unit = unit
        self.category = category
        self.image = image.pngData()
        self.producer = producer
        self.barcode = barcode
    }
    
    func getBarcode() -> String? {
        return barcode
    }
    
    func getProductname() -> String {
        return productname
    }
    
    func getProducer() -> String? {
        return producer
    }
    
    func getPrice() -> Double? {
        return price
    }
    
    func getCurrency() -> String? {
        return currency
    }
    
    func getSize() -> Double? {
        return size
    }
    
    func getUnit() -> String? {
        return unit
    }
    
    func getCategory() -> [String]? {
        return category
    }
    
    
    func getImage() -> UIImage? {
        return UIImage(data: image ?? Data())
    }
    
}

// MARK: 40 Dummy-Produkte (15 Lebensmittel, 15 Getränke, 10 Süßwaren)

// Lebensmittel (15 Produkte)
let foodProducts: [Product] = [
    Product(productname: "Frische Vollmilch", price: 0.89, size: 1000, unit: "ml", category: ["Lebensmittel"], image: UIImage(), producer: "Molkerei Müller"),
    Product(productname: "Bauernbrot", price: 1.99, size: 750, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "Bäckermeister Schmidt"),
    Product(productname: "Frische Eier", price: 2.99, size: 10, unit: "Stück", category: ["Lebensmittel"], image: UIImage(), producer: "Hofladen Bauernhof"),
    Product(productname: "Naturjoghurt", price: 0.99, size: 500, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "BioDairy"),
    Product(productname: "Gouda Käse", price: 2.49, size: 200, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "Käsemanufaktur"),
    Product(productname: "Rindfleisch", price: 8.99, size: 500, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "Fleischerei Meier"),
    Product(productname: "Frischer Lachs", price: 12.99, size: 300, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "Fischmarkt Seebrunn"),
    Product(productname: "Gemischtes Gemüse", price: 2.99, size: 1000, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "GrünLand"),
    Product(productname: "Frisches Obst", price: 3.49, size: 1500, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "Obstparadies"),
    Product(productname: "Bio-Hähnchenbrust", price: 7.99, size: 400, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "BioGeflügel"),
    Product(productname: "Kartoffeln", price: 1.99, size: 2000, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "ErnteFrisch"),
    Product(productname: "Langkornreis", price: 2.99, size: 1000, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "ReisLand"),
    Product(productname: "Spaghetti", price: 1.49, size: 500, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "ItalienFein"),
    Product(productname: "Vollkornnudeln", price: 1.89, size: 500, unit: "g", category: ["Lebensmittel"], image: UIImage(), producer: "PastaPlus"),
    Product(productname: "Extra natives Olivenöl", price: 4.99, size: 750, unit: "ml", category: ["Lebensmittel"], image: UIImage(), producer: "Olivenhof")
]

// Getränke (15 Produkte)
let drinkProducts: [Product] = [
    Product(productname: "Apfelsaft naturtrüb", price: 1.49, size: 1000, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Obstgarten GmbH"),
    Product(productname: "Mineralwasser", price: 0.69, size: 500, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Springquell AG"),
    Product(productname: "Orangensaft", price: 1.59, size: 1000, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "ZitrusFrisch"),
    Product(productname: "Cola", price: 0.99, size: 500, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "ColaCo"),
    Product(productname: "Limonade", price: 1.09, size: 500, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Spritzig GmbH"),
    Product(productname: "Bier (0,5l)", price: 1.99, size: 500, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Brauerei Keller"),
    Product(productname: "Weißwein", price: 3.99, size: 750, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Weingut Sonnenschein"),
    Product(productname: "Rotwein", price: 4.49, size: 750, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Weingut Sonnenschein"),
    Product(productname: "Kaffee (gemahlen)", price: 2.99, size: 250, unit: "g", category: ["Getränke"], image: UIImage(), producer: "Kaffeerösterei"),
    Product(productname: "Schwarzer Tee", price: 1.99, size: 100, unit: "g", category: ["Getränke"], image: UIImage(), producer: "Teehaus"),
    Product(productname: "Energydrink", price: 2.49, size: 250, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "EnergyPlus"),
    Product(productname: "Tonic Water", price: 1.79, size: 1000, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Sprudel AG"),
    Product(productname: "Frischer Smoothie", price: 2.99, size: 350, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "SmoothieBar"),
    Product(productname: "Chai Latte", price: 2.59, size: 300, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "Café Aroma"),
    Product(productname: "Eistee", price: 1.89, size: 500, unit: "ml", category: ["Getränke"], image: UIImage(), producer: "IcedTea Inc.")
]

// Süßwaren (10 Produkte)
let sweetProducts: [Product] = [
    Product(productname: "Schokoladenriegel", price: 0.99, size: 50, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "ChocoDelight"),
    Product(productname: "Gummibärchen", price: 1.29, size: 200, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "SweetTreats"),
    Product(productname: "Lakritz", price: 1.09, size: 100, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "Licorice Love"),
    Product(productname: "Butterkekse", price: 1.49, size: 250, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "KeksManufaktur"),
    Product(productname: "Fruchtgummis", price: 1.39, size: 150, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "GummiFun"),
    Product(productname: "Kaugummi", price: 0.79, size: 50, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "ChewIt"),
    Product(productname: "Marshmallows", price: 1.59, size: 200, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "FluffySweets"),
    Product(productname: "Pralinen", price: 3.49, size: 100, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "ChocoLux"),
    Product(productname: "Zuckerstangen", price: 0.89, size: 80, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "CandyCane"),
    Product(productname: "Müsliriegel", price: 1.29, size: 60, unit: "g", category: ["Süßwaren"], image: UIImage(), producer: "HealthySnack")
]

// Alle Produkte zusammenführen
let products: [Product] = foodProducts + drinkProducts + sweetProducts

// Beispiel: Ausgabe der Produktnamen, Kategorie und Einheit in der Konsole
/*
for product in products {

    print("\(product.productname) - Kategorie: \(product.category ?? "Unbekannt") - Größe: \(product.size ?? 0)\(product.unit ?? "")")
}
*/



