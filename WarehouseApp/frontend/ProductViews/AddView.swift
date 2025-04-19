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
    @State var showPhotoPicker: Bool = false //if the view is supposed to show the PhotoPicker
    @State private var ImagePickerSourceType: UIImagePickerController.SourceType = .camera //default Source for the Picker is camera
    
    @State var showPhotoPickerAlert: Bool = false //the Alert to choose between camera and library
    @State var selectedPhoto: UIImage = UIImage(imageLiteralResourceName: "shoppingCart")
    
    
    //MARK: Variables related to UI Elements (Labels etc.)
    @State var showAddView: Bool = true
    @State var productname: String
    @State var producername: String
    @State var productprice: String
    @State var currency: String
    @State var productDescription: String
    @State var productUnit: String
    @State var productsize: String
    @State var categorystring: String = "Lebensmittel"
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]
    
    
    //MARK: Variable concering ScanView and to check if product was scanned before
    @State var productscanned: Bool = false
    @State var showScanView: Bool = false
   // @State var scanresult: String = ""
    //@State var section: Int? = 0
    
    
    init(product: Product?, scrolltoSection: Binding<Int?>?) {
        
        @State var section: Int? = 0
        self._scrollToSection = scrolltoSection ?? $section
        
        
        if(product != nil)
        {
            self.product = product
        }
        
        _product = State(initialValue: product)
        _productname = State(initialValue: product?.productname ?? "")
        _producername = State(initialValue: product?.producer ?? "")
        _productprice = State(initialValue: String(product?.price ?? 0))
        _currency = State(initialValue: product?.currency ?? "EUR")
        _productDescription = State(initialValue: product?.description ?? "")
        _productUnit = State(initialValue: product?.unit ?? "kg")
        _productsize = State(initialValue: String(product?.size ?? 0))
        _categorystring = State(initialValue: product?.category ?? "Lebensmittel")
        
       // if(scanresult != )
        
        
        
    }
    
    var body: some View {
        NavigationView{
            ScrollViewReader{   proxy in
                    Form{
                        Section{
                            HStack{
                                Spacer()
                                Button(action:{}, label: {
                                    
                                    Image(uiImage: selectedPhoto)
                                        .resizable()
                                        .scaledToFill()
                                    
                                    
                                })
                                .clipShape(Circle())
                                .frame(width: 150, height: 150, alignment: .center)
                                //.padding()
                                Spacer()
                            }
                            
                            HStack{
                                Spacer()
                                Button(action: {  showPhotoPickerAlert = true}, label: {
                                    Text("Foto hinzufügen")
                                        .bold()
                                })
                                .buttonStyle(.borderless)
                                .confirmationDialog("Foto hinzufügen", isPresented: $showPhotoPickerAlert, actions: {
                                    Button("Kamera"){
                                        ImagePickerSourceType = .camera
                                        showPhotoPicker = true
                                    }
                                    .bold()
                                    
                                    Button("Foto hinzufügen")
                                    {
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
                        
                        
                        
                        Section{
                            productDetailsView(productname: $productname, producername: $producername)
                        }
                        .id(1)
                        
                        Section
                        {
                            Picker("Kategorie", selection: $categorystring) {
                                ForEach(filterarray, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                        }
                        .id(2)
                        
                        
                        Section{
                            HStack{
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
                        
                        Section
                        {
                            currencyPicker(selectedCurrency: $currency, productprice: $productprice)
                        }
                        .id(4)
                        
                        Section("Für die Erkennung mithilfe der Kamera")
                        {
                            if(!productscanned)
                            {
                                BarcodeNotScannedView(showScanView: $showScanView)
                            }
                            else
                            {
                                //if produkt already scanned, there needs to be another view
                                BarcodeScannedView(showScanView: $showScanView, product: $product)
                            }
                        }
                        .id(5)
                        
                        
                        /*
                         Section{
                         HStack{
                         Spacer()
                         Button(action: {
                         
                         if(Product != nil)
                         {
                         
                         }
                         
                         dismiss()
                         }, label: {
                         Text("speichern")
                         .fontWeight(.bold)
                         .frame(width: UIScreen.main.bounds.width * 0.85, height: 40)
                         
                         })
                         .bold()
                         .buttonStyle(.borderedProminent)
                         Spacer()
                         }
                         }
                         .listRowBackground(Color.clear)
                         */
                    }
                    .onAppear(perform: {
                        if let section = scrollToSection {
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                       withAnimation {
                                           proxy.scrollTo(section, anchor: .top)
                                       }
                                   }
                               }
                    })
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .navigationTitle("Produkt hinzufügen")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button(action: {
                            dismiss()
                        }, label: {
                            HStack
                            {
                                Image(systemName: "chevron.left")
                                Text("Zurück")
                            }
                        })
                    })
                    
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {
                            //save item
                            //let product = Product(name: "Test", price: 10.0, image: UIImage(systemName: "photo")!)
                            
                            
                            App.shared.addProduct(product ?? Product(barcode: "1"))
                            dismiss()
                        }, label: {
                            
                            Text("speichern")
                                .fontWeight(.bold)
                                //.frame(width: UIScreen.main.bounds.width * 0.85, height: 40)
                        })
                    })
                }
                .sheet(isPresented: $showPhotoPicker, content: {
                    CameraImagePicker(showImagePicker: $showPhotoPicker, image: $selectedPhoto, sourceType: $ImagePickerSourceType)
                })
                .sheet(isPresented: $showScanView, onDismiss: {
                    showScanView = false
                }, content: {
                    ScanView(currentView: self)
                })
                
               
              
            
        }
        
    }
}




struct currencyPicker: View {
    
    @Binding var selectedCurrency: String
    @Binding var productprice: String
    
    var body: some View {
        
        HStack{
            TextField("Preis", text: $productprice)
                .keyboardType(.numbersAndPunctuation)
                //.textContentType(.n)
            Picker("", selection: $selectedCurrency) {
                Text("€").tag("EUR")
                Text("$").tag("USD")
                Text("£").tag("GBP")
            }.labelsHidden()
                .pickerStyle(.menu)
                
        }
    }
}



struct productDetailsView: View {
    
    @Binding var productname: String
    @Binding var producername: String
    
    
    var body: some View
    {
        TextField("Produktbezeichnung", text: $productname)
            .font(.headline)
        TextField("Hersteller/Marke", text: $producername)
        
    }
    
}


struct BarcodeNotScannedView: View {
   @Binding var showScanView: Bool
    
    
    var body: some View {
        HStack
        {
            Button(action: {
                //adding ScanView
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
        
        HStack{
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
        
        Text("scanned Barcode: \(product?.barcode ?? "")")
            .bold()
    }
}
