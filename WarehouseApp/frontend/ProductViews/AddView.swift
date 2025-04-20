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
    
    @State var product: Product?
    @Binding var scrollToSection: Int?
    
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
    @State var categorystring: String = "Lebensmittel"
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]
    
    //MARK: Variable concering ScanView and to check if product was scanned before
    @State var productscanned: Bool = false
    @State var showScanView: Bool = false

  
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                Form {
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
                    .id(0)
                    
                    Section {
                        productDetailsView(productname: $productname, producername: $producername)
                    }
                    .id(1)
                    
                    Section {
                        Picker("Kategorie", selection: $categorystring) {
                            ForEach(filterarray, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .id(2)
                    
                    Section {
                        HStack {
                            TextField("Menge", text: $productsize)
                                .keyboardType(.decimalPad)
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
                    }
                    .id(3)
                    
                    Section {
                        currencyPicker(selectedCurrency: $currency, productprice: $productprice)
                    }
                    .id(4)
                    
                    Section("Für die Erkennung mithilfe der Kamera") {
                        if !productscanned {
                            BarcodeNotScannedView(showScanView: $showScanView)
                        } else {
                            // if produkt already scanned, there needs to be another view
                            BarcodeScannedView(showScanView: $showScanView, product: $product)
                        }
                    }
                    .id(5)
                }
                .onAppear {
                    //MARK: Apply initial product data to form fields
                    if let product = product {
                        productname = product.productname ?? ""
                        producername = product.producer ?? ""
                        productprice = String(product.price ?? 0)
                        currency = product.currency ?? ""
                        productDescription = product.description ?? ""
                        productUnit = product.unit ?? ""
                        productsize = String(product.size ?? 0)
                        categorystring = product.category ?? ""
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
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
                    Button(action: {
                        // save item
                        App.shared.addProduct(product ?? Product(barcode: "1"))
                        dismiss()
                    }, label: {
                        Text("speichern")
                            .fontWeight(.bold)
                    })
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                CameraImagePicker(showImagePicker: $showPhotoPicker, image: $selectedPhoto, sourceType: $ImagePickerSourceType)
            }
            .sheet(isPresented: $showScanView, onDismiss: {
                showScanView = false
            }) {
                ScanView(currentView: self)
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
    @Binding var product: Product?
    
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
        Text("scanned Barcode: \(String(describing: product?.barcode))")
            .bold()
    }
}

