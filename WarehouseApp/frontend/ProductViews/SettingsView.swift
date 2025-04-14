//
//  SettingsView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 26.03.25.
//

import SwiftUI

struct SettingsView: View {
    
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]

    
    @State var downloadProductstoDevice: Bool = false
    
    @State var addcategorysheet: Bool = false
    
    @State var defaultcurrency: String = "EUR"
    
    @State var metric: Bool = true
    
    
    @State var showconfirmationLogoutSheet: Bool = false
    @State var showconfirmationDownloadSheet: Bool = false
    
    var body: some View {
        VStack
        {
            Form
            {
                Section
                {
                    Button(action: {print("pressed")})
                    {
                        HStack{
                            
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            VStack{
                                Text("thiviyan.saravanamuthu@gmail.com")
                                    .lineLimit(1)
                                    .font(.title2)
                                    .bold()
                                
                                Text("tap to change password")
                                
                            }
                            .padding()
                            
                        }
                        .padding()
                    }
                }
                
                Section("Produkte")
                {
                    HStack{
                        Toggle(isOn: $downloadProductstoDevice){
                            Text("Produkte offline verfügbar machen")
                        }
                        .onChange(of: downloadProductstoDevice, {
                            showconfirmationDownloadSheet = downloadProductstoDevice
                        })
                      
                    }
                }
                Section("Kategorien")
                {
                    DisclosureGroup("Kategorien") {
                        List(filterarray, id: \.self){ filter in
                            
                            //FETCH List of categories and FOREACH them here
                            
                            Text(filter)
                                .swipeActions(content: {
                                    Button("Delete") {
                                        print("Delete")
                                    }
                                })
                            
                        }
                    }
                    
                    Button(action:  {})
                    {
                        HStack{
                            Image(systemName: "plus")
                            
                            Text("Kategorie hinzufügen")
                        }
                    }
                    .confirmationDialog("Kategorie hinzufügen?", isPresented: $addcategorysheet, actions: {
                        Text("Kategorie")
                    })
                    
                }
                Section("Währung"){
                    Picker(selection: $defaultcurrency, label: Text("Standardwährung")) {
                        Text("€").tag("EUR")
                        Text("£").tag("GBP")
                        Text("$").tag("USD")
                    }
                    .pickerStyle(.menu)
                    
                  
                }
                
                Section("Einheiten")
                {
                    Toggle(isOn: $metric) {
                        //Text( "Allow multiple categories per product")
                        Text("Metrisches System")
                    }
                }
                
                
                Section{
                    Button(action: {
                        showconfirmationLogoutSheet = true
                        
                    }, label: {
                        HStack{
                            Spacer()
                            Text("Ausloggen")
                                .font(.title3)
                                .tint(Color.red)
                            Spacer()
                        }
                    })
                }
            }
            
        }
        .navigationTitle("Settings")
        .alert("Bist du sicher, dass du dich ausloggen willst?", isPresented: $showconfirmationLogoutSheet, actions: {
            Button("abbrechen", role: .cancel){}
            Button("Logout", role: .destructive){
                logout()
                deleteAppData()
            }
        })
        .alert("Das kann mehr Speicherplatz benötigen. Trotzdem fortfahren?", isPresented: $showconfirmationDownloadSheet, actions:{
            Button("abbrechen", role: .cancel){
                downloadProductstoDevice = false
            }
            Button("download"){
                App.downloadAllProducts()
            }
            .bold()
            .tint(Color.green)
        })
    }
}


func logout() {
    let defaults = UserDefaults.standard
    
    defaults.set(false, forKey: "LoggedIn")
    defaults.set(true, forKey: "FirstLaunch")
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
        
        
        
        window.rootViewController = UIHostingController(rootView: StartupView())
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: {}, completion: {_ in print("Main App activated")})
    }
}


//TODO:
func deleteAppData()
{
    
    
}


