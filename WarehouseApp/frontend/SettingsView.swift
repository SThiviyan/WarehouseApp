//
//  SettingsView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 26.03.25.
//

import SwiftUI

struct SettingsView: View {
    
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]

    @State var multipleCategoriesSelected: Bool = false
    @State var addcategorysheet: Bool = false
    
    @State var defaultcurrency: String = "EUR"
    @State var multiplecurrencyuse: Bool = false
    
    @State var metric: Bool = true
    
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
                Section("Kategorien")
                {
                   
                    HStack{
                        
                        Toggle(isOn: $multipleCategoriesSelected) {
                           //Text( "Allow multiple categories per product")
                            Text("mehrere Kategorien pro Produkt")
                        }
                      
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
                    Button(action: {}, label: {
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
        
    }
}

#Preview {
    SettingsView()
}
