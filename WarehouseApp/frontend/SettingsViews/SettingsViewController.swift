//
//  SettingsViewController.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 28.04.25.
//

import UIKit
import SwiftUI

class SettingsViewController: UITableViewController {

    var app: App! = App.shared

    private var downloadProductsToDevice: Bool = true
    private var metric: Bool = true
    private var defaultCurrency: String = "EUR"
    private var categories: [Category] = []
    private var currencies: [Currency] = []
    private var createdAt: String? = nil
    private var currencyPickerVisible: Bool = false

    private enum Section: Int, CaseIterable {
        case email, products, categories, currency, units, logout, memberSince
    }
    private let switchCellIdentifier = "SwitchCell"
    private let defaultCellIdentifier = "DefaultCell"
    private let pickerCellIdentifier = "PickerCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Einstellungen"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: switchCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: pickerCellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemGroupedBackground

        loadInitialState()
    }

    private func loadInitialState() {
        guard let userData = app.Data.UserData else { return }
        downloadProductsToDevice = userData.saveDataToDevice ?? true
        metric = userData.metric ?? true
        defaultCurrency = userData.currency ?? "EUR"
        createdAt = userData.created_at?.components(separatedBy: "T").first
        categories = app.Data.categories
        currencies = app.Data.currencies
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .email: return 1
        case .products: return 1
        case .categories: return categories.count + 1
        case .currency: return currencyPickerVisible ? 2 : 1
        case .units: return 1
        case .logout: return 1
        case .memberSince: return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .products: return "Produkte"
        case .categories: return "Kategorien"
        case .currency: return "Währung"
        case .units: return "Einheiten"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
            cell.textLabel?.text = app.Data.UserData?.email
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.detailTextLabel?.text = "Passwort ändern"
            cell.accessoryType = .disclosureIndicator
            return cell

        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: switchCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Produkte offline verfügbar machen"
            let toggle = UISwitch()
            toggle.isOn = downloadProductsToDevice
            toggle.addTarget(self, action: #selector(didToggleDownload(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            return cell

        case .categories:
            if indexPath.row < categories.count {
                let category = categories[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
                cell.textLabel?.text = category.name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
                cell.textLabel?.text = "Kategorie hinzufügen"
                cell.textLabel?.textColor = view.tintColor
                return cell
            }

        case .currency:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
                cell.textLabel?.text = "Standardwährung"
                cell.detailTextLabel?.text = currencySymbol(for: defaultCurrency)
                cell.accessoryType = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: pickerCellIdentifier, for: indexPath)
                let picker = UIPickerView(frame: cell.contentView.bounds)
                picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                picker.dataSource = self
                picker.delegate = self
                picker.selectRow(currencies.firstIndex(where: { $0.name == defaultCurrency }) ?? 0,
                                 inComponent: 0, animated: false)
                cell.contentView.addSubview(picker)
                return cell
            }

        case .units:
            let cell = tableView.dequeueReusableCell(withIdentifier: switchCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Metrisches System"
            let toggle = UISwitch()
            toggle.isOn = metric
            toggle.addTarget(self, action: #selector(didToggleMetric(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            return cell

        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Ausloggen"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemRed
            return cell

        case .memberSince:
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Mitglied seit \(createdAt ?? "Unbekannt")"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .email:
            let hostingVC = UIHostingController(rootView: ChangePasswordView().environmentObject(app))
            navigationController?.pushViewController(hostingVC, animated: true)

        case .categories:
            if indexPath.row == categories.count {
                presentAddCategoryAlert()
            }

        case .currency:
            currencyPickerVisible.toggle()
            tableView.reloadSections(IndexSet(integer: Section.currency.rawValue), with: .automatic)

        case .logout:
            presentLogoutConfirmation()

        default:
            break
        }
    }

    // MARK: actions
    @objc private func didToggleDownload(_ sender: UISwitch) {
        downloadProductsToDevice = sender.isOn
        app.Data.UserData?.saveDataToDevice = downloadProductsToDevice
        presentDownloadConfirmation()
    }

    @objc private func didToggleMetric(_ sender: UISwitch) {
        metric = sender.isOn
        app.Data.UserData?.metric = metric
    }

    // MARK: helpers
    private func presentAddCategoryAlert() {
        let alert = UIAlertController(title: "Neue Kategorie", message: "Wie soll deine neue Kategorie heißen?", preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = "Neue Kategorie" }
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .default) { _ in
            let name = alert.textFields?.first?.text ?? ""
            if !self.app.addCategory(category: Category(name: name)) {
                self.presentCategoryExistsAlert()
            } else {
                self.categories = self.app.Data.categories
                self.tableView.reloadSections(IndexSet(integer: Section.categories.rawValue), with: .automatic)
            }
        })
        present(alert, animated: true)
    }

    private func presentCategoryExistsAlert() {
        let alert = UIAlertController(title: "Kategorie bereits hinzugefügt", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }

    private func presentDownloadConfirmation() {
        let alert = UIAlertController(title: "Speicherplatz Hinweis", message: "Das kann mehr Speicherplatz benötigen. Trotzdem fortfahren?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel) { _ in
            self.downloadProductsToDevice = false
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: Section.products.rawValue)], with: .automatic)
        })
        alert.addAction(UIAlertAction(title: "Download", style: .default) { _ in
            Task { /* await App.shared.fetchAllProducts() */ }
        })
        present(alert, animated: true)
    }

    private func presentLogoutConfirmation() {
        let alert = UIAlertController(title: "Bist du sicher, dass du dich ausloggen willst?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.app.logout()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UIHostingController(rootView: StartupView())
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: {})
            }
        })
        present(alert, animated: true)
    }

    private func currencySymbol(for name: String) -> String {
        return currencies.first(where: { $0.name == name })?.symbol ?? name
    }
}

// MARK: UiPickerView DataSource & Delegate
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencies[row].symbol
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newCurrency = currencies[row].name
        defaultCurrency = newCurrency
        app.Data.UserData?.currency = newCurrency
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.currency.rawValue)], with: .automatic)
    }
}
