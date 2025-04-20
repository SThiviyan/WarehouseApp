//
//  LookUpView.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 22.03.25.
//

import SwiftUI

struct LookUpView: View {
    
    @EnvironmentObject var appstate: App
    @Binding var product: Product?
    //MARK: Infuse this view with a Product from App class
    
    @State var ProducerName: String = "Producer"
    @State var ProductName: String = "Product"
    @State var Description: String = "Description"
    
    @State var ProductHasBarcode: Bool = true
    @State var productBarcode: String = "0"
    
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
                        .opacity(product?.description == "" ? 0 : 1)
                    
                }
                
                
                Section("Kategorie")
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
                        BarcodeScannedView(showScanView: $ShowScanView, barcode: $productBarcode)
                    }
                    else
                    {
                        BarcodeNotScannedView(showScanView: $ShowScanView)
                    }
                }
            }
            
        }
        .onAppear(perform: {
            print(product?.barcode)
            productBarcode = product?.barcode ?? "0"
        })
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
            AddView(product: $product, scrollToSection: $ScrollToSection)
            
        })
        .sheet(isPresented: $ShowAddView, onDismiss: {
            ShowAddView = false
        },content: {
            AddView(product: $product, scrollToSection: $ScrollToSection)
        })
        .onChange(of: ShowScanView, {
            if(ShowScanView == true)
            {
                ScrollToSection = 5
            }
            else{
                ScrollToSection = 0
            }
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
