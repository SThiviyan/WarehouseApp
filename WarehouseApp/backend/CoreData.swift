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
    
    private init() {
        
    }


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
    
    
    
    //ALL APPDATA IS SAVED
    func saveAppData(data: AppData) -> Bool {
        let context = persistenceContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreAppData> = CoreAppData.fetchRequest()

        let coreAppData: CoreAppData = (try? context.fetch(fetchRequest).first) ?? CoreAppData(context: context)
        
        //Sync date needs to be updated 
        coreAppData.lastSync = Date()

        //Categories
        let newCategoryNames = Set(data.categories.map { $0.name })
        let existingCategoryNames = Set((coreAppData.categories as? Set<CoreCategory>)?.compactMap { $0.name } ?? [])
        //checks if somethings been added / removed, and then rewrites the categorynames
        if newCategoryNames != existingCategoryNames {
            (coreAppData.categories as? Set<CoreCategory>)?.forEach { context.delete($0) }
            let categoryObjects = data.categories.map {
                let category = CoreCategory(context: context)
                category.name = $0.name
                return category
            }
            coreAppData.categories = NSSet(array: categoryObjects)
        }

        // Units (same process as categories)
        let newUnits = Set(data.units.map { $0.name })
        let existingUnits = Set((coreAppData.units as? Set<CoreUnit>)?.compactMap { $0.name } ?? [])
        if newUnits != existingUnits {
            (coreAppData.units as? Set<CoreUnit>)?.forEach{ context.delete($0) }
            let unitObjects = data.units.map {
                let unit = CoreUnit(context: context)
                unit.name = $0.name
                unit.shortname = $0.shortname
                return unit
            }
            coreAppData.units = NSSet(array: unitObjects)
        }

        // Currencies (same process as currencies)
        let newCurrency = Set(data.currencies.map { $0.name })
        let existingCurrency = Set((coreAppData.currencies as? Set<CoreCurrency>)?.compactMap { $0.name } ?? [])
        if newCurrency != existingCurrency {
            (coreAppData.currencies as? Set<CoreCurrency>)?.forEach { context.delete($0) }
            let currencyObjects = data.currencies.map {
                let currency = CoreCurrency(context: context)
                currency.name = $0.name
                currency.symbol = $0.symbol
                return currency
            }
            coreAppData.currencies = NSSet(array: currencyObjects)
        }
        
        
        //LateRequests
        let newLateRequests = Set(data.lateRequests.map {$0.timeStamp})
        let existingLateRequests = Set((coreAppData.lateuploadrequests as? Set<CoreLateUploadRequest>)?.compactMap { $0.timestamp } ?? [])
        
        if newLateRequests != existingLateRequests {
            (coreAppData.lateuploadrequests as? Set<CoreLateUploadRequest>)?.forEach { context.delete($0)}
            
            let lateRequestObjects = data.lateRequests.map {
                let lateRequest = CoreLateUploadRequest(context: context)
                lateRequest.timestamp = $0.timeStamp
                
                var uploadType = 0
                if($0.uploadtype == 1)
                {
                    uploadType = 1
                }
                lateRequest.uploadType = Int16(uploadType)
                lateRequest.object = $0.object
                
                return lateRequest
            }
            
        }
        
        

        // User Data
        if let oldUser = coreAppData.userData {
            context.delete(oldUser)
        }
        let userData = CoreUser(context: context)
        userData.email = data.UserData?.email ?? ""
        userData.password = data.UserData?.password ?? ""
        userData.login_method = data.UserData?.login_method ?? ""
        userData.lastJWT = data.UserData?.lastJWT ?? ""
        userData.metric = data.UserData?.metric ?? true
        userData.is_active = data.UserData?.is_active ?? true
        userData.created_at = data.UserData?.created_at ?? ""
        if let currencyName = data.UserData?.currency,
           let currency = (coreAppData.currencies as? Set<CoreCurrency>)?.first(where: { $0.name == currencyName }) {
            userData.currency = currency
        }
        coreAppData.userData = userData

            
        do {
            try context.save()
        } catch {
            print("Failed to save app data: \(error)")
            return false
        }
        
        if(!saveProducts(data: data))
        {
            return false
        }
      
        
        print("========================")
        print("Data saved to COREDATA")
        print("========================")
        return true
    }

    
    
    func getAppData() -> AppData?
    {
        let fetchRequest: NSFetchRequest<CoreAppData> = CoreAppData.fetchRequest()
        var data: AppData = AppData()
        
        
        if let appData = try? (persistenceContainer.viewContext.fetch(fetchRequest).first)
        {
            print("Logged in with \(String(describing: appData.userData?.email))")
            
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
            
            
            //currency retrievals
            let currencies = appData.currencies?.compactMap({ (value) -> Currency? in
                guard let cCurrency = value as? CoreCurrency else { return nil }
                let curreny = Currency(name: cCurrency.name!, symbol: cCurrency.symbol!)
                return curreny
            })
            
            //category retrievals
            var categories = appData.categories?.compactMap({ (value) -> Category? in
                guard let cCategory = value as? CoreCategory else { return nil }
                let category = Category(name: cCategory.name!)
                return category
            })
            
            //unit retrievals
            let units = appData.units?.compactMap({ (value) -> Unit? in
                guard let coreUnit = value as? CoreUnit else { return nil }
                let unit = Unit(name: coreUnit.name!, shortname: coreUnit.shortname!)
                return unit
            })
            
            
            //LateRequestRetrieval (should ideally be empty)
            let latereqs = appData.lateuploadrequests?.compactMap({ (value) -> LateUploadRequest? in
                guard let coreLateReq = value as? CoreLateUploadRequest else { return nil }
                let lateReq = LateUploadRequest(uploadtype: Int(coreLateReq.uploadType), object: coreLateReq.object!, objectType: coreLateReq.objectType!, timeStamp: coreLateReq.timestamp!)
                return lateReq
            })
            
            
            //MARK: Products get saved in memory, except images (only urls)
            var products = appData.products?.compactMap({ (value) -> Product? in
                guard let corePr = value as? CoreProduct else { return nil }
                var product = Product(productname: corePr.name ?? "", price: corePr.price, size: corePr.size, category: [corePr.category?.name ?? ""], producer: corePr.producer ?? "", barcode: corePr.barcode ?? "", createdAt: corePr.createdAt ?? Date())
                
                product.productImage = productImage(DeviceFilePath: corePr.image?.deviceFileName ?? "", ServerFilePath: corePr.image?.serverFileName, ServerThumbnailFilePath: corePr.image?.serverThumbnailFileName, uploadedToServer: corePr.image?.uploadedToServer ?? false)
                
                return product
            })
            
            products?.sort(by: {productA, productB in
                productA.createdAt < productB.createdAt
            })
            
            categories?.sort(by: {
                 categoryA, categoryB in
                categoryA.name < categoryB.name
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
    
    
    func saveProducts(data: AppData) -> Bool
    {
        let fetchRequest: NSFetchRequest<CoreAppData> = CoreAppData.fetchRequest()
        let context = persistenceContainer.viewContext
        let coreAppData: CoreAppData = (try? context.fetch(fetchRequest).first) ?? CoreAppData(context: context)

        
        
        //
        //  All Products
        //
        
        let existingProducts = (coreAppData.products as? Set<CoreProduct>) ?? []
        let eCurrency = coreAppData.currencies as? Set<CoreCurrency>
        let eCategory = coreAppData.categories as? Set<CoreCategory>
        let eUnit = coreAppData.units as? Set<CoreUnit>
        
        //Deletion of products that are in CoreData but not in App Memory
        (coreAppData.products as? Set<CoreProduct>)?.forEach { pr in
            if(!data.products.contains(where: { $0.deviceid == pr.id}))
            {
                coreAppData.removeFromProducts(pr)
                context.delete(pr)
            }
        }
        
      
        //Adding a Product if its not in the existingProducts Set, but in the Data array
        for pr in data.products {
            if !existingProducts.contains(where: {$0.id == pr.deviceid})
            {
                let newProduct: CoreProduct = CoreProduct(context: context)
                newProduct.id = pr.deviceid
                newProduct.serverId = Int64(pr.serverId ?? -1)
                newProduct.name = pr.productname
                newProduct.barcode = pr.barcode
                newProduct.producer = pr.producer
                newProduct.productdescription = pr.description
                newProduct.price = pr.price ?? 0.0
                newProduct.size = pr.size ?? 0.0
                newProduct.createdAt = pr.createdAt
                
                newProduct.unit = eUnit?.first(where: {
                    $0.name == pr.unit ?? ""
                })
                newProduct.currency = eCurrency?.first(where: {
                    $0.name == pr.currency ?? ""
                })
                
                newProduct.category = eCategory?.first(where: {
                    $0.name == pr.category ?? ""
                })
                
                let corePr = CoreProductImage(context: context)
                corePr.deviceFileName = pr.productImage?.DeviceFilePath
                corePr.serverFileName = pr.productImage?.ServerFilePath
                corePr.serverThumbnailFileName = pr.productImage?.ServerThumbnailFilePath
                
                //Second check, in case uploaded to Server wasn't updated
                var uploaded: Bool = false
                if(pr.productImage?.ServerFilePath != nil) {
                    uploaded = true
                }
                
                corePr.uploadedToServer = pr.productImage?.uploadedToServer ?? uploaded
                
                newProduct.image = corePr
                
                
                coreAppData.addToProducts(newProduct)
            }
        }
        
        do{
            try context.save()
            return true
        }
        catch {
            print("Failed to save app data: \(error)")
            return false
        }
    }
    
    
    
    //OBSOLETE METHOD 
    func addProduct(to appData: CoreAppData, item: Product) -> CoreProduct
    {
        let context = persistenceContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreProduct> = CoreProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.deviceid as CVarArg)
        
        
        let coreProduct: CoreProduct
        
        do
        {
            let product = try (persistenceContainer.viewContext.fetch(fetchRequest).first) ?? CoreProduct(context: context)
            
            
            product.id = item.deviceid
            product.serverId = Int64(item.serverId ?? 0)
            product.name = item.productname
            product.barcode = item.barcode ?? ""
            product.producer = item.producer
            product.productdescription = item.description
            product.price = item.price ?? 0
            product.size = item.size ?? 0
            product.createdAt = item.createdAt
            
            
            let CategoryRequest: NSFetchRequest<CoreCategory> = CoreCategory.fetchRequest()
            CategoryRequest.predicate = NSPredicate(format: "name == %@", item.category ?? "" as CVarArg)
                
            if let existingCategory = try? context.fetch(CategoryRequest).first {
                product.category = existingCategory
            }
            else{
                product.category = nil
            }
        
            
            let unitRequest: NSFetchRequest<CoreUnit> = CoreUnit.fetchRequest()
            unitRequest.predicate = NSPredicate(format: "name == %@", item.unit ?? "" as CVarArg)
            
            if let existingUnit = try? context.fetch(unitRequest).first {
                product.unit = existingUnit
            }
            else{
                product.unit = nil
            }
        
            
            let currencyRequest: NSFetchRequest<CoreCurrency> = CoreCurrency.fetchRequest()
            currencyRequest.predicate = NSPredicate(format: "name == %@", item.currency ?? "" as CVarArg)
        
            if let existingCurrency = try? context.fetch(currencyRequest).first {
                product.currency = existingCurrency
            }
            else{
                product.currency = nil
            }
            
            coreProduct = product
            appData.addToProducts(coreProduct)
            
            
            try context.save()
        }
        catch{
            return CoreProduct(context: context)
        }
        
       
        return coreProduct
    }
    
    
    func getAllImageNames() -> [productImage]
    {
        let context = persistenceContainer.viewContext
        let productImageRequest: NSFetchRequest<CoreProductImage> = CoreProductImage.fetchRequest()
        
        var ProductImageArray: [productImage] = []
        
        if let coreproductImgArray: [CoreProductImage] = try? context.fetch(productImageRequest) {
            
            ProductImageArray = coreproductImgArray.compactMap({ value in
                let productImage: productImage = productImage(DeviceFilePath: value.deviceFileName ?? "", ServerFilePath: value.serverFileName, ServerThumbnailFilePath: value.serverThumbnailFileName, uploadedToServer: value.uploadedToServer)
                return productImage
            })
            
        }
        
        return ProductImageArray
    }
    
    
  
    
    func deleteAllCoreDataObjects() 
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
       
    }
}
