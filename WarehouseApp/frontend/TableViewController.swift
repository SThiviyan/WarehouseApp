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
    var section: Int? = 0
    var product: Product?
    let imageLoader: ImageLoader = ImageLoader()
    
    let searchbar: UISearchBar = {
        let s = UISearchBar()
        
        s.placeholder = "Suche"
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
    
    var collectionViewHeightConstraint: NSLayoutConstraint?
    var currentCategories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Suche"
        self.navigationItem.largeTitleDisplayMode = .always
            
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButton_pressed))
        
        searchbar.delegate = self
        
        table.register(tablecell.self, forCellReuseIdentifier: tablecell.identifier)
        table.delegate = self
        table.dataSource = self
        table.prefetchDataSource = self
        view.addSubview(searchbar)
        view.addSubview(table)
        view.addSubview(horizontalfilterscroll)
        horizontalfilterscroll.alpha = 0
        
        
        setconstraints()
        
        collectionViewHeightConstraint = horizontalfilterscroll.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
        
        currentCategories = app.Data.categories
        
        fetchVisibleCellsImages()
    }
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        app.selectedProduct = nil

        
        //horizontalfilterscroll.reloadData()
        
        if(currentCategories.count != app.Data.categories.count)
        {
            if app.Data.categories.count > 0 {
                collectionViewHeightConstraint?.constant = 50
            }
            else
            {
                collectionViewHeightConstraint?.constant = 0
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.horizontalfilterscroll.alpha = 1
            })
            
            var indexpaths: [IndexPath] = []

            if(currentCategories.count < app.Data.categories.count)
            {
                
                
                for i in currentCategories.count..<app.Data.categories.count{
                    indexpaths.append(IndexPath(row: i, section: 0))
                }
                
                horizontalfilterscroll.insertItems(at: indexpaths)
                
                for i in currentCategories.count..<app.Data.categories.count{
                    if let cell  = horizontalfilterscroll.cellForItem(at: IndexPath(row: i, section: 0)) {
                        UIView.animate(withDuration: 0.25) {
                            cell.layoutIfNeeded()
                        }
                    }
                }
            }
            else
            {
                 for i in 0..<currentCategories.count{
                    
                     if(!app.Data.categories.contains(where: { $0.name == currentCategories[i].name}))
                     {
                         horizontalfilterscroll.deleteItems(at: [IndexPath(row: i, section: 0)])
                         
                         
                         if let cell  = horizontalfilterscroll.cellForItem(at: IndexPath(row: i, section: 0)) {
                             UIView.animate(withDuration: 0.25) {
                                 cell.layoutIfNeeded()
                             }
                         }
                     }
                }
                
                
            }
          
                
            
            
            currentCategories = app.Data.categories
        }
        
        
        
    
        fetchVisibleCellsImages()
        
        
        UIView.animate(withDuration: 0.25, animations: {
            self.table.reloadData()
            self.table.visibleCells.forEach { $0.layoutIfNeeded() }
        })
       
    }
    
    func fetchVisibleCellsImages()
    {
        let visibleIndex = table.indexPathsForVisibleRows
        print("VISIBLECELLS: \(visibleIndex)")
        var urls: [String] = []
        
        visibleIndex?.forEach({
            index in
            
            print("index \(index.row)")
            print("image: \(app.Data.products[index.row].productImage?.DeviceFilePath)")
            
            urls.append(app.Data.products[index.row].productImage?.DeviceFilePath ?? "")
        })
        
        imageLoader.prefetch(urls: urls)
    }
    
    @objc func plusButton_pressed()
    {
        let addViewSwiftUI = AddView(isEditing: false, scrollToSection: section, onSave: {
            DispatchQueue.main.async {
                self.table.reloadData()
                self.fetchVisibleCellsImages()
            }
        })
            .environmentObject(app)
        let hostingcontroller = UIHostingController(rootView: addViewSwiftUI)
        hostingcontroller.navigationItem.title = "Produkt hinzufügen"
        
        
        
        //presentationController.prefersGrabberVisible = true
        //present(hostingcontroller, animated: true)
        present(hostingcontroller, animated: true)
    }
    
    func setconstraints()
    {
        NSLayoutConstraint.activate([
            searchbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchbar.heightAnchor.constraint(equalToConstant: 50),
            horizontalfilterscroll.topAnchor.constraint(equalTo: searchbar.bottomAnchor),
            horizontalfilterscroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            horizontalfilterscroll.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -10),
            table.topAnchor.constraint(equalTo: horizontalfilterscroll.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            table.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
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


extension TableViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.Data.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        fetchVisibleCellsImages()
 
        let cell = tableView.dequeueReusableCell( withIdentifier: tablecell.identifier, for: indexPath) as! tablecell
        
        let imagefilepath = app.Data.products[indexPath.row].productImage?.DeviceFilePath
        cell.configure(product: app.Data.products[indexPath.row], img: imageLoader.getImage(url: imagefilepath))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //let vc = LookUpVC()
        
        let cell = tableView.cellForRow(at: indexPath) as! tablecell
        
       
        print("cellproduct----------------------")
        print(cell.product)
        print("---------------------------------")
        
        app.selectedProduct = cell.product
        
        let vc = UIHostingController(rootView: LookUpView(product: cell.product).environmentObject(App.shared))
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls: [String] = indexPaths.map {
            app.Data.products[$0.row].productImage?.DeviceFilePath ?? ""
        }
        
        imageLoader.prefetch(urls: urls)
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            
            let cell = tableView.cellForRow(at: indexPath) as! tablecell
            let product = cell.getProduct()
            self.app.removeProduct(product)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
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
        return app.Data.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCell.identifier, for: indexPath) as! filterCell
        cell.configure(productcategory: app.Data.categories[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell
        
        cell.selected()
        
        //TODO: backend implementation of filters
        
    }
}








