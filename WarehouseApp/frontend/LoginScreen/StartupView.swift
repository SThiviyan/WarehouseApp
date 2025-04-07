//
//  LoginView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 06.04.25.
//

import SwiftUI

struct StartupView: View {
    
   @State var showlogin: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                
                Spacer()
                HStack{
                
                    Text("Willkommen bei Warehouse!")
                        .padding()
                        .font(.largeTitle)
                    Spacer()
                }
                .padding()
                .padding(.bottom, -60)
                                
                HStack(alignment: .center){
                    
                    Spacer()
                    
                    VStack{
                        
                        Spacer()
                        
                        Image(systemName: "door.garage.open")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.blue)
                        
                        Spacer()
                        
                        Image(systemName: "vial.viewfinder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.blue)
                            
                        
                        Spacer()
                        
                        Image(systemName: "sparkle.magnifyingglass")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.blue)
                        
                        Spacer()
                    }
                    .padding()
                
                    VStack(alignment: .leading){
                        
                        Spacer()
                        
                        Text("Alle deine Produkte, gespeichert an einem Ort")
                            .bold()
                        
                        Spacer()
                        
                        Text("Scannen, notwendige Informationen eintragen und fertig!")
                            .bold()
                        
                        Spacer()
                        
                        Text("Scannen, nachschlagen, und mehr...")
                            .bold()
                        
                        Spacer()
                    }
                    .padding()

                    
                    
                }
               // .frame(height: 550)
                
                

                
                Button(action: {
                    showlogin = true
                }, label: {
                    
                    Text("Einloggen")
                        .frame(width: 300, height: 60)
                        .background(Color.blue)
                        .clipShape(.buttonBorder)
                        .buttonStyle(.borderedProminent)
                        .buttonStyle(.automatic)
                        .tint(.white)
                        .bold()
                })
                
            }
        
        }
        .sheet(isPresented: $showlogin) {
                LoginView()
        }
    }
    
}

#Preview {
    StartupView()
}
