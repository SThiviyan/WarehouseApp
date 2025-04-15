//
//  SettingsView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 26.03.25.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var app = App.shared
    //MARK: INFUSE WITH APP CLASS DATA
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]

    
    @State var downloadProductstoDevice: Bool = false
    
    @State var addcategorysheet: Bool = false
    
    @State var defaultcurrency: String = "EUR"
    
    @State var metric: Bool = true
    
    
    @State var showconfirmationLogoutSheet: Bool = false
    @State var showconfirmationDownloadSheet: Bool = false
    
    @State var showaddcategorysheet: Bool = false
    @State var newcategoryname: String = ""
    @State var categoryalreadyadded: Bool = false
    
    @State var showChangePasswordSheet: Bool = false
    
    var createdAt: String?
    
    
    
    init() {
        _downloadProductstoDevice = State(initialValue: ((app.Data.UserData?.saveDataToDevice) ?? false))
        _metric = State(initialValue: ((app.Data.UserData?.metric) ?? true))
        _defaultcurrency = State(initialValue: ((app.Data.UserData?.currency) ?? "EUR"))
        
        //Kategorien hinzufügen
        
        
        createdAt = app.Data.UserData?.created_at?
            .split(separator: "T")
            .first
            .map(String.init)
      
    }
    
    var body: some View {
        VStack
        {
            Form
            {
                Section
                {
                    Button(action: {
                        showChangePasswordSheet = true
                    })
                    {
                        HStack{
                            
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            VStack{
                                Text(verbatim: "thiviyan.saravanamuthu@gmail.com")
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
                    
                    Button(action:  {
                        addcategorysheet.toggle()
                    })
                    {
                        HStack{
                            Image(systemName: "plus")
                            
                            Text("Kategorie hinzufügen")
                        }
                    }
                    
                    
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
                
                Section{
                    HStack{
                        Spacer()
                        Text("Mitglied seit \(createdAt ?? "Unknown Date")")
                            .font(.caption)
                            .bold()
                        Spacer()
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            
        }
        .navigationTitle("Settings")
        .alert("Bist du sicher, dass du dich ausloggen willst?", isPresented: $showconfirmationLogoutSheet, actions: {
            Button("abbrechen", role: .cancel){}
            Button("Logout", role: .destructive){
                
                app.logout()
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                    
                    
                    
                    window.rootViewController = UIHostingController(rootView: StartupView())
                    window.makeKeyAndVisible()
                    
                    UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: {}, completion: {_ in print("Main App activated")})
                }
              
            }
        })
        .alert("Das kann mehr Speicherplatz benötigen. Trotzdem fortfahren?", isPresented: $showconfirmationDownloadSheet, actions:{
            Button("abbrechen", role: .cancel){
                downloadProductstoDevice = false
            }
            Button("download"){
                App.shared.downloadAllProducts()
            }
            .bold()
            .tint(Color.green)
        })
        .sheet(isPresented: $showChangePasswordSheet, content: {
            ChangePasswordView()
        })
        .alert("Wie soll deine neue Kategorie heißen?", isPresented: $addcategorysheet, actions: {
            TextField("neue Kategorie", text: $newcategoryname)
            Button("abbrechen", role: .cancel, action:{
                
            })
            Button("hinzufügen", action: {
                
                if(app.addCategory(name: newcategoryname))
                {
                    
                }
                else{
                    categoryalreadyadded.toggle()
                }
            })
        })
        .alert("Kategorie bereits hinzugefügt", isPresented: $categoryalreadyadded, actions: {
            Button("okay", role: .cancel, action: {
                
            })
        })
        
    }
}



