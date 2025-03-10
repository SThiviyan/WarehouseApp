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
    let searchbar: UISearchBar = {
        let s = UISearchBar()
        
        s.placeholder = "Search"
        s.translatesAutoresizingMaskIntoConstraints = false
        s.layer.borderWidth = 0
        s.backgroundImage = UIImage()
        return s
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.navigationItem.largeTitleDisplayMode = .always
      
        view.addSubview(searchbar)
        searchbar.delegate = self

        
        setconstraints()
        
    }
    
    
    func setconstraints()
    {
        NSLayoutConstraint.activate([
            searchbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            //searchbar.heightAnchor.constraint(equalToConstant: 50)
        ])
    
    }
    
    
}



extension TableViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    
}
