//
//  Product.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 11.03.25.
//
import UIKit


struct Product: Codable {
    
    var deviceid: UUID
    var serverId: Int?
    
    var barcode: String?
    var productname: String?
    var producer: String?
    
    var description: String?
    
    var price: Double?
    var currency: String?
    
    var size: Double?
    var unit: String?
    
    var category: String?
    var createdAt: Date = Date()
    
    //UIIMAGE does not conform to codable, there is a better solution to this!
    var productImage: productImage?
    
    // Initializer mit zusätzlichen Parametern und Default-Werten für optionale Eigenschaften
    // productImage needs to be assigned differently
    init(productname: String,
         price: Double,
         currency: String? = "EUR",
         size: Double,
         unit: String? = "g",   // z. B. "g" oder "ml"
         category: [String],
         producer: String,
         barcode: String?,
         createdAt: Date) {
        
        
        self.deviceid = UUID()
        self.productname = productname
        self.price = price
        self.currency = currency
        self.size = size
        self.unit = unit
        self.category = category[0]
        self.producer = producer
        self.barcode = barcode
        self.createdAt = createdAt
    }
    
    init(productname: String,
         price: Double,
         currency: String? = "EUR",
         size: Double,
         unit: String? = "g",   // z. B. "g" oder "ml"
         category: [String],
         producer: String,
         barcode: String?,
         productImage: productImage,
         createdAt: Date) {
        
        
        self.deviceid = UUID()
        self.productname = productname
        self.price = price
        self.currency = currency
        self.size = size
        self.unit = unit
        self.category = category[0]
        self.producer = producer
        self.barcode = barcode
        self.createdAt = createdAt
        self.productImage = productImage
    }
    
    
    init(CoreP: CoreProduct) {
        
        
        self.deviceid = CoreP.id!
        self.serverId = Int(CoreP.serverId)
        self.productname = CoreP.name
        self.price = CoreP.price
        self.currency = CoreP.currency?.name
        self.size = CoreP.size
        self.unit = CoreP.unit?.name
        self.category = CoreP.category?.name
        self.producer = CoreP.producer
        self.barcode = CoreP.barcode
        self.createdAt = CoreP.createdAt!
    }
    
    
    init(initialID: UUID, product: Product)
    {
        self.deviceid = initialID
        self.serverId = product.serverId
        self.productname = product.productname
        self.producer = product.producer
        self.price = product.price
        self.size = product.size
        self.currency = product.currency
        self.unit = product.unit
        self.category = product.category
        self.barcode = product.barcode
        self.createdAt = product.createdAt
        
        //MARK: IF SERVER IMAGE UPLOAD IS IMPLEMENTED SOME THINGS MAY NEED TO BE CHANGED
        self.productImage = WarehouseApp.productImage(DeviceFilePath: product.productImage?.DeviceFilePath ?? "", uploadedToServer: false)
    }
    
    
    
    init()
    {
        self.deviceid = UUID()
        self.productname = ""
        self.price = 0.0
        self.currency = "EUR"
        self.size = 0.0
        self.unit = "kg"
        self.category = "Lebensmittel"
        self.producer = ""
        self.barcode = ""
    }
    
    
    init(barcode: String)
    {
        self.deviceid = UUID()
        self.productname = ""
        self.price = 0.0
        self.currency = "EUR"
        self.size = 0.0
        self.unit = "kg"
        self.category = "Lebensmittel"
        self.producer = ""
        self.barcode = barcode
    }
    
  
}







/*
func getDummyProducts() -> [Product]
{
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
    
    return products
}


func getDummyCategories() -> [Category] {
    return [Category(name: "Lebensmittel"),
            Category(name: "Getränke"),
            Category(name: "Haushaltswaren"),
            Category(name: "Süßwaren"),
            Category(name: "Spielzeug"),
            Category(name: "Schreibwaren")
    ]
}
*/
