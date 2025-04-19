//
//  TableViewController.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 10.03.25.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI

class TableViewController: UIViewController
{
    
    
    //MARK: INFUSE WITH APP DATA FROM APP CLASS
    let app = App.shared
    
    @State var filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]
    
    
    let searchbar: UISearchBar = {
        let s = UISearchBar()
        
        s.placeholder = "Search"
        s.translatesAutoresizingMaskIntoConstraints = false
        s.layer.borderWidth = 0
        s.backgroundImage = UIImage()
        return s
    }()
    
    
    let table: UITableView =
    {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.rowHeight = 80
        return t
    }()
    
    lazy var horizontalfilterscroll: UICollectionView =
    {
      
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 10
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.itemSize = CGSize(width: view.frame.width / 3, height: 40)
        
        let t = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(filterCell.self, forCellWithReuseIdentifier: filterCell.identifier)
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.showsHorizontalScrollIndicator = false
        t.isScrollEnabled = true
    
        //t.backgroundColor = .clear
        
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.navigationItem.largeTitleDisplayMode = .always
            
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButton_pressed))
        
      
        view.addSubview(searchbar)
        searchbar.delegate = self

        
        table.register(tablecell.self, forCellReuseIdentifier: tablecell.identifier)
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        
        view.addSubview(horizontalfilterscroll)

        
        setconstraints()
        
    }
    
    
    @objc func plusButton_pressed()
    {
        print("add product")
                
        @State var section: Int? = 0
        let addViewSwiftUI = AddView(product: nil, scrolltoSection: $section)
        let hostingcontroller = UIHostingController(rootView: addViewSwiftUI)
        hostingcontroller.navigationItem.title = "Produkt hinzufügen"
        
        
        
        //presentationController.prefersGrabberVisible = true
        present(hostingcontroller, animated: true)

    }
    
    func setconstraints()
    {
        NSLayoutConstraint.activate([
            searchbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            //searchbar.heightAnchor.constraint(equalToConstant: 50)
            
            horizontalfilterscroll.topAnchor.constraint(equalTo: searchbar.bottomAnchor),
            horizontalfilterscroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            horizontalfilterscroll.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -10),
            horizontalfilterscroll.heightAnchor.constraint(equalToConstant: 50),
            
            table.topAnchor.constraint(equalTo: horizontalfilterscroll.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            table.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -100)
            
        ])
    
    }
    
    
}



extension TableViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        
        
        //table.reloadData()
    }
    
    
    
}


extension TableViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.Data.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( withIdentifier: tablecell.identifier, for: indexPath) as! tablecell
        
        cell.configure(product: app.Data.products[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //let vc = LookUpVC()
        
        let cell = tableView.cellForRow(at: indexPath) as! tablecell
                
        let vc = UIHostingController(rootView: LookUpView(product: cell.product).environmentObject(App.shared))
        
        
        print(App.shared.Data.products[indexPath.row])
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
        
        //vc.title = products[indexPath.row].productname ?? ""
         
        
    }
    
    
 
}



extension TableViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func reloadCollectionView()
    {
        DispatchQueue.main.async {
            [weak self] in
            self?.horizontalfilterscroll.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCell.identifier, for: indexPath) as! filterCell
        cell.configure(productcategory: filterarray[indexPath.row])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell
        
        cell.selected()
        
        //TODO: backend implementation of filters
        
    }
}








