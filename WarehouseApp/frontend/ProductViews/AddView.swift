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
    
    
    @ObservedObject var app = App.shared
    
    @State var Product: Product?
    
    
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
    
    
    init(product: Product?) {
        
        
        if(product != nil)
        {
            self.Product = product
        }
        
        _Product = State(initialValue: product)
        _productname = State(initialValue: product?.productname ?? "")
        _producername = State(initialValue: product?.producer ?? "")
        _productprice = State(initialValue: String(product?.price ?? 0))
        _currency = State(initialValue: product?.currency ?? "eur")
        _productDescription = State(initialValue: product?.description ?? "")
        _productUnit = State(initialValue: product?.unit ?? "kg")
        _productsize = State(initialValue: String(product?.size ?? 0))
        _categorystring = State(initialValue: product?.category ?? "Lebensmittel")
    }
    
    var body: some View {
        NavigationView{
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
                  
                    
                    
                    Section{
                        TextField("Produktbezeichnung", text: $productname)
                            .font(.headline)
                        TextField("Hersteller/Marke", text: $producername)
                        
                        
                    }
                    
                    Section
                    {
                        Picker("Kategorie", selection: $categorystring) {
                            ForEach(filterarray, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.menu)
                    }
                    
                   
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
                    
                    Section{
                        HStack{
                            TextField("Preis", text: $productprice)
                                .keyboardType(.numbersAndPunctuation)
                                //.textContentType(.n)
                            Picker("", selection: $currency) {
                                Text("€").tag("EUR")
                                Text("$").tag("USD")
                                Text("£").tag("GBP")
                            }.labelsHidden()
                                .pickerStyle(.menu)
                                
                        }
                       
                    }
                    
                    Section("Für die Erkennung mithilfe der Kamera")
                    {
                        HStack
                        {
                            if(!productscanned)
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
                            
                            else
                            {
                                //if produkt already scanned, there needs to be another view
                            }
                        }
                        
                    }
                    
                    
                    
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


                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .navigationTitle("Produkt hinzufügen")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button("Zurück")
                        {
                            dismiss()
                        }
                    })
                }
                .sheet(isPresented: $showPhotoPicker, content: {
                    CameraImagePicker(showImagePicker: $showPhotoPicker, image: $selectedPhoto, sourceType: $ImagePickerSourceType)
                })
                .sheet(isPresented: $showScanView, onDismiss: {
                    showScanView = false
                    //ScanView.UIViewControllerType().openedViaAddView = false
                }, content: {
                    ScanView()
                })
                
               
              
            
        }
        
    }
}




