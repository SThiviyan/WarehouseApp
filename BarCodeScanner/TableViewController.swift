//
//  TableViewController.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 10.03.25.
//

import Foundation
import UIKit
import AVFoundation

class TableViewController: UIViewController
{
    
    let array = ["Produkt1","Produkt2","Produkt3","Produkt4","Produkt5","Produkt6"]
    
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
        
        //t.rowHeight = 10
        t.translatesAutoresizingMaskIntoConstraints = false
        
        return t
    }()
    
    lazy var horizontalfilterscroll: UICollectionView =
    {
        let t = UICollectionView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: 98, height: 134)
        flowlayout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        flowlayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowlayout.minimumInteritemSpacing = 0.0
        
        t.collectionViewLayout = flowlayout
        
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.navigationItem.largeTitleDisplayMode = .always
      
        view.addSubview(searchbar)
        searchbar.delegate = self

        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        
        view.addSubview()

        
        setconstraints()
        
    }
    
    
    func setconstraints()
    {
        NSLayoutConstraint.activate([
            searchbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            //searchbar.heightAnchor.constraint(equalToConstant: 50)
            
            table.topAnchor.constraint(equalTo: searchbar.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            table.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    
    }
    
    
}



extension TableViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    
}


extension TableViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
 
}



extension TableViewController: UICollectionViewDelegate
{
    
    
    
}
