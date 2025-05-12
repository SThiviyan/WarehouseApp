//
//  AddView.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 18.03.25.
//

import SwiftUI
import UIKit
import PhotosUI

struct AddView: View {

    //MARK: INFUSE DATA FROM APP CLASS (HERE IT NEEDS TO BE OPTIONAL, BECAUSE YOU CAN ADD NEW PRODUCTS WITHOUT ANY DETAILS AND YOU CAN EDIT ALREADY CREATED PRODUCTS
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var app: App

    @State var product: Product? = nil
    @State var tempProduct: Product? = nil
    @State var isEditing: Bool = false
    @State var scrollToSection: Int?
    var onSave: (()->Void)? = nil

    //MARK: Variables related to the photo Picker
    @State var showPhotoPicker: Bool = false // if the view is supposed to show the PhotoPicker
    @State private var ImagePickerSourceType: UIImagePickerController.SourceType = .camera // default Source for the Picker is camera

    @State var showPhotoPickerAlert: Bool = false // the Alert to choose between camera and library
    @State var selectedPhoto: UIImage = UIImage(imageLiteralResourceName: "shoppingCart")

    //MARK: Variables related to UI Elements (Labels etc.)
    @State var showAddView: Bool = true
    @State var productname: String = ""
    @State var producername: String = ""
    @State var productprice: String = ""
    @State var currency: String = "EUR"
    @State var productDescription: String = ""
    @State var productUnit: String = "kg"
    @State var productsize: String = ""
    @State var categorystring: String = ""

    //MARK: Variable concering ScanView and to check if product was scanned before
    @State var productscanned: Bool = false
    @State var productbarcode: String = "0"
    @State var showScanView: Bool = false
    
    
    @State var showemptyfieldalert: Bool = false
    @State var errorAlert: Bool = false
    
    @State var calledOverScanView: Bool = false
    @State var parsedScanView: ScanViewController? = nil

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                formContent(proxy: proxy)
            }
            .navigationTitle("Produkt hinzufügen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                        
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Zurück")
                        }
                    })
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: saveProduct, label: {
                        Text("speichern")
                            .fontWeight(.bold)
                    })
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                CameraImagePicker(showImagePicker: $showPhotoPicker, image: $selectedPhoto, sourceType: $ImagePickerSourceType)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showScanView, onDismiss: {
                showScanView = false
            }) {
                ScanView(currentView: self)
            }
            .onDisappear(perform: {
                productname = ""
                producername = ""
                productprice = ""
                currency = ""
                productDescription = ""
                productUnit = ""
                productsize = ""
                categorystring = ""
                
                if(calledOverScanView)
                {
                    if(parsedScanView != nil)
                    {
                        DispatchQueue.global(qos: .userInteractive).async(execute: {
                            parsedScanView!.captureSession.startRunning()
                            })
                    }
                    calledOverScanView = false
                }
            })
            
            
        }
    }

    // MARK: Extracted View Builder
    func formContent(proxy: ScrollViewProxy) -> some View {
        Form {
            photoSection
                .id(0)

            Section { productDetailsView(productname: $productname, producername: $producername) }
                .id(1)

            if(!app.Data.categories.isEmpty){
                categoryPickerSection
                    .id(2)
                    .environmentObject(app)
            }

            descriptionSection
                .id(3)

            priceSection
                .id(4)

            barcodeSection
                .id(5)
        }
        .onAppear {
            //MARK: Apply initial product data to form fields
            
            product = app.selectedProduct
            
            if let product = product {
                productname = product.productname ?? ""
                producername = product.producer ?? ""
                productprice = String(product.price ?? 0)
                currency = product.currency ?? ""
                productDescription = product.description ?? ""
                productUnit = product.unit ?? ""
                productsize = String(product.size ?? 0)
                categorystring = product.category ?? ""
                isEditing = true
                selectedPhoto = app.Storage.getImage(name: product.productImage?.DeviceFilePath ?? "") ?? UIImage(imageLiteralResourceName: "shoppingCart")
                
                tempProduct = product
                
               
            }
            
            if(product == nil)
            {
                if(app.Data.categories.count > 0)
                {
                    categorystring = app.Data.categories[0].name
                }
            }

            //MARK: Automatically scroll to specific section if requested
            if let section = scrollToSection {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        proxy.scrollTo(section, anchor: .top)
                    }
                }
            }
        }
        .alert("Fehler", isPresented: $showemptyfieldalert, actions: {
            Button("okay", role: .cancel)
            {}},
            message: { Text("Die Produktbezeichnung darf nicht leer sein!")})
        .alert("Fehler", isPresented: $errorAlert, actions: {
            Button("okay", role: .cancel)
            {}},
            message: { Text("Es gab einen Fehler beim hinzufügen des Produktes. Probiere es später noch einmal!")})
        
    }

    var photoSection: some View {
        Section {
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Image(uiImage: selectedPhoto)
                        .resizable()
                        .scaledToFill()
                })
                .clipShape(Circle())
                .frame(width: 150, height: 150, alignment: .center)
                Spacer()
            }

            HStack {
                Spacer()
                Button(action: {
                    showPhotoPickerAlert = true
                }, label: {
                    Text("Foto hinzufügen")
                        .bold()
                })
                .buttonStyle(.borderless)
                .confirmationDialog("Foto hinzufügen", isPresented: $showPhotoPickerAlert, actions: {
                    Button("Kamera") {
                        ImagePickerSourceType = .camera
                        showPhotoPicker = true
                    }
                    .bold()

                    Button("Foto hinzufügen") {
                        ImagePickerSourceType = .photoLibrary
                        showPhotoPicker = true
                    }
                })
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    var categoryPickerSection: some View {
        Section {
            Picker("Kategorie", selection: $categorystring) {
                ForEach(app.Data.categories, id: \.name) { category in
                    Text(category.name).tag(category.name)
                }
            }
            .pickerStyle(.menu)
        }
    }
        

    var descriptionSection: some View {
        Section {
            HStack {
                TextField("Menge", text: $productsize)
                    .keyboardType(.decimalPad)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                Picker("", selection: $productUnit) {
                    Text("Mililiter").tag("ml")
                    Text("Liter").tag("l")
                    Text("Gramm").tag("g")
                    Text("Kilogrammm").tag("kg")
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }
            TextField("Beschreibung", text: $productDescription)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    var priceSection: some View {
        Section {
            currencyPicker(selectedCurrency: $currency, productprice: $productprice)
        }
    }

    var barcodeSection: some View {
        Section("Für die Erkennung mithilfe der Kamera") {
            if !productscanned {
                BarcodeNotScannedView(showScanView: $showScanView)
            } else {
                BarcodeScannedView(showScanView: $showScanView, barcode: $productbarcode)
            }
        }
    }

    // MARK: Save Function
    func saveProduct() {
        
        //
        // Product save prep
        //
        var barcode = productbarcode
        if(barcode == "")
        {
            barcode = "0"
        }
        
        let img = selectedPhoto
        var deviceFileName = ""
       
        if(img != UIImage(imageLiteralResourceName: "shoppingCart"))
        {
            deviceFileName = UUID().uuidString
        }
        
        let pr = Product(productname: productname,
                         price: Double(productprice) ?? 0.0,
                         currency: currency,
                         size: Double(productsize) ?? 0.0,
                         unit: productUnit,
                         category: [categorystring],
                         producer: producername,
                         barcode: barcode,
                         productImage: productImage(DeviceFilePath: deviceFileName, uploadedToServer: false),
                         createdAt: Date())
        
       
        
        // Not sure if necessary
        product = pr
        
        
        
        if(calledOverScanView)
        {
            isEditing = false
        }

        //
        // SAVING PRODUCT
        //
        if(productname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        {
            showemptyfieldalert = true
        }
        else
        {
            showemptyfieldalert = false
            
            if isEditing
            {
                //TODO: FIX ISSUE HERE 
                isEditing = false
                if App.shared.setProduct(newproduct: pr, oldproduct: tempProduct!, newImage: img) == true {
                    app.selectedProduct = product
                    dismiss()
                }
                else
                {
                    errorAlert = true
                }
            }
            else
            {
                isEditing = false
                if App.shared.addProduct(pr, image: img) == true {
                    onSave?()
                    dismiss()
                }
                else
                {
                    errorAlert = true
                }
            }
        }
        
    }
}

// MARK: Additional Views
struct AddViewPhotoView: View {
    @State var image: UIImage?
    @State var showImagePicker: Bool = false

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct currencyPicker: View {
    @Binding var selectedCurrency: String
    @Binding var productprice: String

    var body: some View {
        HStack {
            TextField("Preis", text: $productprice)
                .keyboardType(.numbersAndPunctuation)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            Picker("", selection: $selectedCurrency) {
                Text("€").tag("EUR")
                Text("$").tag("USD")
                Text("£").tag("GBP")
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
    }
}

struct productDetailsView: View {
    @Binding var productname: String
    @Binding var producername: String

    var body: some View {
        TextField("Produktbezeichnung", text: $productname)
            .font(.headline)
        TextField("Hersteller/Marke", text: $producername)
    }
}

struct BarcodeNotScannedView: View {
    @Binding var showScanView: Bool

    var body: some View {
        HStack {
            Button(action: {
                // adding ScanView
                showScanView = true
            }, label: {
                Text("Barcode Scannen")
                    .bold()
            })
            Spacer()
            Image(systemName: "camera")
                .foregroundStyle(.blue)
        }
    }
}

struct BarcodeScannedView: View {
    @Binding var showScanView: Bool
    @Binding var barcode: String

    var body: some View {
        HStack {
            Button(action: {
                showScanView = true
            }, label: {
                Text("Barcode erneut Scannen")
                    .bold()
            })
            Spacer()
            Image(systemName: "camera")
                .foregroundStyle(.blue)
        }
        Text("scanned Barcode: \(String(describing: barcode))")
            .bold()
    }
}
