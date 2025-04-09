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
    
    @State var multipleCategoriesSelected: Bool = false
    @State var addcategorysheet: Bool = false
    
    @State var defaultcurrency: String = "EUR"
    @State var multiplecurrencyuse: Bool = false
    
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
                            ActionSheet(title: Text("Produkte offline verfügbar machen"), message: Text("Wenn du offline verfügbar machst, kannst du deine App ohne Internetverbindung nutzen."), buttons: [.default(Text("OK"))])
                        })
                      
                    }
                }
                Section("Kategorien")
                {
                    
                    HStack{
                        
                        Toggle(isOn: $multipleCategoriesSelected) {
                            //Text( "Allow multiple categories per product")
                            Text("mehrere Kategorien pro Produkt")
                        }
                        .onChange(of: multipleCategoriesSelected, perform: {newValue in 
                           //TODO: backend
                        })
                        
                        
                        
                    }
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
                    
                    Toggle(isOn: $multiplecurrencyuse) {
                        //Text( "Allow multiple categories per product")
                        Text("mehrere Währungen nutzen")
                    }
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
        .alert("Are you sure that you want to logout?", isPresented: $showconfirmationLogoutSheet, actions: {
            Button("cancel", role: .cancel){}
            Button("Logout", role: .destructive){
                logout()
                deleteAppData()
            }
        })
        .alert("Wenn du alle Produkte offline verfügbar machst, kann das Speicherplatz in anspruch nehmen. Trotzdem fortfahren?", isPresented: $showconfirmationDownloadSheet, actions:{
            Button("cancel", role: .cancel){}
            Button("download", role: .cancel){
                App.downloadAllProducts()
                
            }
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


