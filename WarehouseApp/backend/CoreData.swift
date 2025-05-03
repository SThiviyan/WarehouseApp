//
//  CoreData.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 24.04.25.
//


import Foundation
import CoreData
import UIKit

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    
    lazy var persistenceContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AppData")
        
        container.loadPersistentStores{ _, error in
            
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        
        
        return container
        
    }()
    
    private init() {}


    func hasAppData() -> Bool
    {
        
        let fetchRequest: NSFetchRequest<CoreAppData> = CoreAppData.fetchRequest()
        
        if let appData = try? (persistenceContainer.viewContext.fetch(fetchRequest).first)
        {
            if(appData.userData?.email == nil || ((appData.userData?.email?.isEmpty) == nil))
            {
                return false
            }
            else
            {
                return true
            }
        }
        return false
    }
    
    func saveAppData(data: AppData) -> Bool
    {
        let context = persistenceContainer.viewContext
        
        let AppdataObject = CoreAppData(context: context)
        
        let CategoryObjects: [CoreCategory] = data.categories.map { value in
            let category = CoreCategory(context: context)
            category.name = value.name
            return category
        }
        
        let UnitObjects: [CoreUnit] = data.units.map { value in
            let unit = CoreUnit(context: context)
            unit.name = value.name
            unit.shortname = value.shortname
            return unit
        }
        
        let currencyObjects: [CoreCurrency] = data.currencies.map { value in
            let currency = CoreCurrency(context: context)
            currency.symbol = value.symbol
            currency.name = value.name
            return currency
        }
        
        let UserData: CoreUser = CoreUser(context: context)
        UserData.email = data.UserData?.email!
        UserData.password = data.UserData?.password!
        UserData.login_method = data.UserData?.login_method!
        UserData.lastJWT = data.UserData?.lastJWT!
        UserData.metric =  data.UserData?.metric ?? true
        UserData.is_active = data.UserData?.is_active ?? true
        UserData.created_at = data.UserData?.created_at!
        
        let index = currencyObjects.firstIndex(where: {$0.name == (data.UserData?.currency) ?? "EUR"})
        let currency = currencyObjects[index ?? 0]
        UserData.currency = currency
        
        
        let products: [CoreProduct] = data.products.map { value in
            let cProduct = CoreProduct(context: context)
            cProduct.id = value.deviceid
            cProduct.serverId = Int64(value.serverId ?? -1) //IF -1 then product not uploaded to Server
            cProduct.barcode = value.barcode
            cProduct.name = value.productname
            cProduct.producer = value.producer
            cProduct.size = value.size ?? -1 //NO PRICE WHEN NEGATIVE
            cProduct.price = value.price ?? -1 //NO PRICE WHEN NEGATIVE
            cProduct.productdescription = value.description
            
            //currency search
            
            
            //unit search
            
            
            //category search
            
            
            //image
            
            
            return cProduct
        }
        
        
        
        AppdataObject.products = NSSet(array: products)
        AppdataObject.categories = NSSet(array: CategoryObjects)
        AppdataObject.units = NSSet(array: UnitObjects)
        AppdataObject.currencies = NSSet(array: currencyObjects)
        AppdataObject.userData = UserData
       
        do
        {
            try context.save()
        }
        catch{
            return false
        }
        
        return true
    }
    
    
    
    func getAppData() -> AppData?
    {
        let fetchRequest: NSFetchRequest<CoreAppData> = CoreAppData.fetchRequest()
        var data: AppData = AppData()
        
        if let appData = try? (persistenceContainer.viewContext.fetch(fetchRequest).first)
        {
            print("Logged in with \(appData.userData?.email)")
            
            var user = User()  // Create an empty user object

            user.id = Int(appData.userData?.id ?? 0)
            user.email = appData.userData?.email ?? ""
            user.password = appData.userData?.password ?? ""
            user.login_method = appData.userData?.login_method ?? ""
            user.is_active = appData.userData?.is_active ?? true
            user.created_at = appData.userData?.created_at ?? ""
            user.currency = appData.userData?.currency?.name
            user.metric = appData.userData?.metric
            user.lastJWT = appData.userData?.lastJWT ?? ""
            user.saveDataToDevice = true
            
            if(user.email == "" || user.password == "")
            {
                deleteAllCoreDataObjects() // TODO: ?
                return nil
            }
            
            
            let currencies = appData.currencies?.compactMap({ (value) -> Currency? in
                guard let cCurrency = value as? CoreCurrency else { return nil }
                let curreny = Currency(name: cCurrency.name!, symbol: cCurrency.symbol!)
                return curreny
            })
            
            let categories = appData.categories?.compactMap({ (value) -> Category? in
                guard let cCategory = value as? CoreCategory else { return nil }
                let category = Category(name: cCategory.name!)
                return category
            })
            
            let units = appData.units?.compactMap({ (value) -> Unit? in
                guard let coreUnit = value as? CoreUnit else { return nil }
                let unit = Unit(name: coreUnit.name!, shortname: coreUnit.shortname!)
                return unit
            })
            
            
            //TODO: PRODUCTS
            let products = appData.products?.compactMap({ (value) -> Product? in
                guard let corePr = value as? CoreProduct else { return nil }
                let product = Product(productname: corePr.name ?? "", price: corePr.price, size: corePr.size, category: [corePr.category?.name ?? ""], image: UIImage(), producer: corePr.producer ?? "")
                
                return product
            })
            
            
            data.UserData = user
            data.categories = categories ?? []
            data.units = units ?? []
            data.currencies = currencies ?? []
            data.products = products ?? []
            
            return data
        }
        
        return nil
    }
    
    
    func saveProduct(item: Product) -> Bool
    {
        let context = persistenceContainer.viewContext
        
        let product = CoreProduct(context: context)
        
        product.id = item.deviceid
        product.serverId = Int64(item.serverId ?? 0)
        product.name = item.productname
        product.barcode = item.barcode
        product.producer = item.producer
        product.productdescription = item.description
        product.price = item.price ?? 0
        product.size = item.size ?? 0
        
        let fetchRequest: NSFetchRequest<CoreCategory> = CoreCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", item.category ?? "" as CVarArg)
        
        
        if let existingCategory = try? context.fetch(fetchRequest).first {
            product.category = existingCategory
        }
        else{
            return false
        }
        
        let unitRequest: NSFetchRequest<CoreUnit> = CoreUnit.fetchRequest()
        unitRequest.predicate = NSPredicate(format: "name == %@", item.unit ?? "" as CVarArg)
        
        
        if let existingUnit = try? context.fetch(unitRequest).first {
            product.unit = existingUnit
        }
        else{
            return false
        }
    
        
        let currencyRequest: NSFetchRequest<CoreCurrency> = CoreCurrency.fetchRequest()
        currencyRequest.predicate = NSPredicate(format: "name == %@", item.currency ?? "" as CVarArg)
    
        if let existingCurrency = try? context.fetch(currencyRequest).first {
            product.currency = existingCurrency
        }
        else{
            return false
        }
       
        
        do {
           try context.save()
        }
        catch {
            return false
        }
        
        return true
    }
    
    
    func deleteProduct(item: Product) -> Bool
    {
        let context = persistenceContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreProduct> = CoreProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.deviceid as CVarArg)
        
        //let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        return true
    }
    
    
    func addCategory(oldCategory: Category?, newCategory: Category) -> Bool
    {
        return true
    }
    
    
    func deleteCategory(category: Category) -> Bool
    {
        return true
    }
    
    
    func deleteAllCoreDataObjects() -> Bool
    {
        let context = persistenceContainer.viewContext
        let entities = context.persistentStoreCoordinator?.managedObjectModel.entities
        
        entities?.forEach { entity in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch {
                print("Error deleting \(entity.name ?? "Unknown Entity"): \(error)")
            }
            
            do {
                try context.save()
            }
            catch{
                print("Failed to save context after batch delete \(error)")
            }
        }
       
        return true
    }
}
