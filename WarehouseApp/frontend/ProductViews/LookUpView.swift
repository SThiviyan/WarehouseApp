//
//  LookUpView.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 22.03.25.
//

import SwiftUI

struct LookUpView: View {
    
    @State var ProducerName: String = "Producer"
    @State var ProductName: String = "Product"
    @State var Description: String = "Description"
    
    @State var ProductHasBarcode: Bool = true
    
    //Previous Views
    @State var ShowScanView: Bool = false
    @State var ShowAddView: Bool = false
    
    //For Toggle
    @State var ScanningIsOn: Bool = true
    
    
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
                        Text(ProducerName)
                            .font(.title2)
                            .bold()
                            .padding(.top)
                        Text(Description)
                    }
                    
                    Section("Preis")
                    {
                        HStack{
                            Spacer()
                            Text("3.99€ für 500 Stück")
                                .font(.largeTitle)
                                .padding()
                                .bold()
                            Spacer()
                        }
                        
                    }
                    
                    Section("Scanning")
                    {
                        if(ProductHasBarcode)
                        {
                            Toggle(isOn: $ScanningIsOn) {
                                Text("Barcode Scanning")
                            }
                        }
                        else
                        {
                            HStack{
                                Button(action: {
                                    //adding ScanView
                                    ShowScanView = true
                                    
                                    
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
                }
                // MARK: Kategorie muss hier noch hinzugefügt werden
                    
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Bearbeiten")
                    {
                        ShowAddView = true
                    }
                })
            }
            .sheet(isPresented: $ShowScanView, content: {
                //ScanView speicherung muss gemacht werden, bzw. Parameter für die View, damit man weiß für welches Objekt man speichern muss
                ScanView()
            })
            .sheet(isPresented: $ShowAddView, content: {
                //AddView muss das Objekt, bzw. die ObjektID bekommen, damit alles zur Bearbeitung ausgefüllt werden kann
                AddView()
            })
        }
        
    
        
}

#Preview {
    LookUpView()
    
}
