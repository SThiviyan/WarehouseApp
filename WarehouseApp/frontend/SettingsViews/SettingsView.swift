//
//  SettingsView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 26.03.25.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var app: App
    

    @State var downloadProductstoDevice: Bool = true
    @State var addcategorysheet: Bool = false
    @State var defaultcurrency: String = "EUR"
    @State var metric: Bool = true
    @State var showconfirmationLogoutSheet: Bool = false
    @State var showconfirmationDownloadSheet: Bool = false
    @State var newcategoryname: String = ""
    @State var categoryalreadyadded: Bool = false
    @State var showChangePasswordSheet: Bool = false
    @State var createdAt: String? = nil

    var body: some View {
            Form {
                //MARK: WORKAROUND REQUIRED BECAUSE SWIFTUI BUGS OUT WHEN NAVIGATIONBARTITLE AND COREDATA ARE USED SIMULTANEOUSLY
                
                
                //MARK: i hate SwiftUI so much
                
                emailSection
                productSection
                categorySection
                currencySection
                unitSection
                logoutSection
                memberSinceSection
                
            }
            .alert("Bist du sicher, dass du dich ausloggen willst?", isPresented: $showconfirmationLogoutSheet) {
                Button("abbrechen", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    app.logout()
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = UIHostingController(rootView: StartupView())
                        window.makeKeyAndVisible()
                        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: {})
                    }
                }
                .alert("Das kann mehr Speicherplatz benötigen. Trotzdem fortfahren?", isPresented: $showconfirmationDownloadSheet) {
                    Button("abbrechen", role: .cancel) {
                        downloadProductstoDevice = false
                    }
                    Button("download") {
                        Task{
                            //MARK: ADD FETCHING
                            //await App.shared.fetchAllProducts()
                        }
                    }
                    .bold()
                    .tint(.green)
                }
                .sheet(isPresented: $showChangePasswordSheet) {
                    ChangePasswordView()
                }
                .alert("Wie soll deine neue Kategorie heißen?", isPresented: $addcategorysheet) {
                    TextField("neue Kategorie", text: $newcategoryname)
                    Button("abbrechen", role: .cancel) {}
                    Button("hinzufügen") {
                        if !app.addCategory(category: Category(name: newcategoryname)) {
                            categoryalreadyadded.toggle()
                        }
                        
                        newcategoryname = ""
                    }
                }
                .alert("Kategorie bereits hinzugefügt", isPresented: $categoryalreadyadded) {
                    Button("okay", role: .cancel) {}
                }
                
                .onAppear {
                    downloadProductstoDevice = app.Data.UserData?.saveDataToDevice ?? true
                    metric = app.Data.UserData?.metric ?? true
                    defaultcurrency = app.Data.UserData?.currency ?? "EUR"
                    createdAt = app.Data.UserData?.created_at?
                        .split(separator: "T")
                        .first
                        .map(String.init)
                    
                }
                .onChange(of: app.Data.UserData?.created_at, {
                    createdAt = app.Data.UserData?.created_at
                })
            }
        

        
        
        
    }

    // MARK: Sections

    private var emailSection: some View {
        Section {
            Button(action: {
                showChangePasswordSheet = true
            }) {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 60, height: 60)

                    VStack(alignment: .leading) {
                        Text(verbatim: app.Data.UserData?.email ?? "")
                            .lineLimit(1)
                            .font(.title2)
                            .bold()
                        Text("tap to change password")
                    }
                    .padding(.leading, 8)
                }
                .padding()
            }
        }
    }

    private var productSection: some View {
        Section("Produkte") {
            Toggle(isOn: $downloadProductstoDevice) {
                Text("Produkte offline verfügbar machen")
            }
            .onChange(of: downloadProductstoDevice) {
                showconfirmationDownloadSheet = downloadProductstoDevice
                app.Data.UserData?.saveDataToDevice = downloadProductstoDevice
            }
        }
    }

    private var categorySection: some View {
        Section("Kategorien") {
            DisclosureGroup("Kategorien") {
                ForEach(app.Data.categories, id: \.name) { filter in
                    Text(filter.name)
                        .swipeActions {
                            Button("Delete") {
                                print("Delete \(filter)")
                                app.removeCategory(filter)
                            }
                        }
                }
            }
            Button(action: {
                addcategorysheet.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Kategorie hinzufügen")
                }
            }
        }
    }

    private var currencySection: some View {
        Section("Währung") {
            Picker(selection: $defaultcurrency, label: Text("Standardwährung")) {
                ForEach(app.Data.currencies, id: \.name) { currency in
                    Text(currency.symbol).tag(currency.name)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: defaultcurrency) {
                app.Data.UserData?.currency = defaultcurrency
            }
        }
    }

    private var unitSection: some View {
        Section("Einheiten") {
            Toggle(isOn: $metric) {
                Text("Metrisches System")
            }
            .onChange(of: metric) {
                app.Data.UserData?.metric = metric
            }
        }
    }

    private var logoutSection: some View {
        Section {
            Button(action: {
                showconfirmationLogoutSheet = true
            }) {
                HStack {
                    Spacer()
                    Text("Ausloggen")
                        .font(.title3)
                        .tint(.red)
                    Spacer()
                }
            }
        }
    }

    private var memberSinceSection: some View {
        Section {
            HStack {
                Spacer()
                Text("Mitglied seit \(app.Data.UserData?.created_at ?? "Unbekannt")")
                    .font(.caption)
                    .bold()
                Spacer()
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

