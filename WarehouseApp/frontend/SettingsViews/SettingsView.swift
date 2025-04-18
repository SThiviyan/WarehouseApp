//
//  SettingsView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 26.03.25.
//


import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var app = App.shared
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]

    @State var downloadProductstoDevice: Bool = true
    @State var addcategorysheet: Bool = false
    @State var defaultcurrency: String = "EUR"
    @State var metric: Bool = true
    @State var showconfirmationLogoutSheet: Bool = false
    @State var showconfirmationDownloadSheet: Bool = false
    @State var newcategoryname: String = ""
    @State var categoryalreadyadded: Bool = false
    @State var showChangePasswordSheet: Bool = false
    
    var createdAt: String?
    
    init() {
        _downloadProductstoDevice = State(initialValue: app.Data.UserData?.saveDataToDevice ?? true)
        _metric = State(initialValue: app.Data.UserData?.metric ?? true)
        _defaultcurrency = State(initialValue: app.Data.UserData?.currency ?? "EUR")
        
        createdAt = app.Data.UserData?.created_at?
            .split(separator: "T")
            .first
            .map(String.init)
    }
    
    var body: some View {
        VStack {
            Form {
                emailSection
                productSection
                categorySection
                currencySection
                unitSection
                logoutSection
                memberSinceSection
            }
        }
        .navigationTitle("Settings")
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
        }
        .alert("Das kann mehr Speicherplatz benötigen. Trotzdem fortfahren?", isPresented: $showconfirmationDownloadSheet) {
            Button("abbrechen", role: .cancel) {
                downloadProductstoDevice = false
            }
            Button("download") {
                App.shared.downloadAllProducts()
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
                if !app.addCategory(name: newcategoryname) {
                    categoryalreadyadded.toggle()
                }
            }
        }
        .alert("Kategorie bereits hinzugefügt", isPresented: $categoryalreadyadded) {
            Button("okay", role: .cancel) {}
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
                        Text(verbatim: "thiviyan.saravanamuthu@gmail.com")
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
            .onChange(of: downloadProductstoDevice, {
                showconfirmationDownloadSheet = downloadProductstoDevice
                app.Data.UserData?.saveDataToDevice = downloadProductstoDevice
                print(app.Data.UserData)
            })
        }
    }
    
    private var categorySection: some View {
        Section("Kategorien") {
            DisclosureGroup("Kategorien") {
                ForEach(filterarray, id: \.self) { filter in
                    Text(filter)
                        .swipeActions {
                            Button("Delete") {
                                print("Delete \(filter)")
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
                Text("€").tag("EUR")
                Text("£").tag("GBP")
                Text("$").tag("USD")
            }
            .pickerStyle(.menu)
            .onChange(of: defaultcurrency, {
                app.Data.UserData?.currency = defaultcurrency
                print(app.Data.UserData)
            })
        }
    }
    
    private var unitSection: some View {
        Section("Einheiten") {
            Toggle(isOn: $metric) {
                Text("Metrisches System")
            }
            .onChange(of: metric, {
                app.Data.UserData?.metric = metric
                print(app.Data.UserData)
            })
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
                Text("Mitglied seit \(createdAt ?? "Unbekannt")")
                    .font(.caption)
                    .bold()
                Spacer()
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

