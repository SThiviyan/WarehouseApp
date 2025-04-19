//
//  LookUpView.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 22.03.25.
//

import SwiftUI

struct LookUpView: View {
    
    @ObservedObject var appstate = App.shared
    @State var product: Product?
    //MARK: Infuse this view with a Product from App class
    
    @State var ProducerName: String = "Producer"
    @State var ProductName: String = "Product"
    @State var Description: String = "Description"
    
    @State var ProductHasBarcode: Bool = true
    
    //Previous Views
    @State var ShowScanView: Bool = false
    @State var ShowAddView: Bool = false
    
    //For Toggle
    @State var ScanningIsOn: Bool = true
    
    @State var ScrollToSection: Int? = 5
    
    var body: some View {
        
        VStack{
            
            Form{
                
                Section
                {
                    HStack
                    {
                        Spacer()
                        Image("shoppingCart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(.circle)
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                Section("Details")
                {
                    Text(product?.productname ?? "")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    Text(product?.producer ?? "")
                    Text(product?.description ?? "")
                    
                }
                
                
                Section("Category")
                {
                    Text(product?.category ?? "")
                }
                
                Section("Preis")
                {
                    HStack{
                        Spacer()
                        Text(getPriceSizeString(price: product?.price, currency: product?.currency, size: product?.size, unit: product?.unit))
                            .font(.largeTitle)
                            .padding()
                            .bold()
                        Spacer()
                    }
                    
                }
                
                Section("Scanning")
                {
                    if(product?.barcode != "0")
                    {
                        BarcodeScannedView(showScanView: $ShowScanView, product: $product)
                    }
                    else
                    {
                        BarcodeNotScannedView(showScanView: $ShowScanView)
                    }
                }
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction, content: {
                Button("Bearbeiten")
                {
                    ShowAddView = true
                }
            })
        }
        .sheet(isPresented: $ShowScanView, onDismiss: {
            ShowScanView = false
        },content: {
            //ScanView speicherung muss gemacht werden, bzw. Parameter für die View, damit man weiß für welches Objekt man speichern muss
            //ScanView()
            AddView(product: product, scrolltoSection: $ScrollToSection)
            
        })
        .sheet(isPresented: $ShowAddView, onDismiss: {
            ShowAddView = false
        },content: {
            AddView(product: product, scrolltoSection: nil)
        })
        .onChange(of: ShowScanView, {
            App.shared.setProduct(product ?? Product(barcode: "1"))
        })
        }
        
    
        
}




func getPriceSizeString(price: Double?, currency: String?, size: Double?, unit: String?) -> String {
   if(price != nil && currency != nil && size != nil && unit != nil)
    {
       let price = String(format: "%.2f", price ?? 0.0) + (currency ?? "")
       let size = String(size ?? 0) + (unit ?? "")
       
       
       return "\(price) für \(size)"
   }
    else
    {
        return "-"
    }
}
