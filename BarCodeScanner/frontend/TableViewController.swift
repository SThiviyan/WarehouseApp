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
    
    let array = ["Pfanner Eistee","Coca Cola Zero ","Fanta","Kinder Cards","Chipsfrisch Ungarisch","Aptamil Milch","Mehl Ja!","Nescafe taps","pringles chips","Bild Zeitung"]
    let searcharray = ["Pfanner Eistee","Coca Cola Zero ","Fanta","Kinder Cards","Chipsfrisch Ungarisch","Aptamil Milch","Mehl Ja!","Nescafe taps","Pringles Chips","Bild Zeitung"]
    let pricearray = ["2€", "4,99€", "5,99€", "1€", "12,99€", "0,99€", "4€", "6€", "8€", "12€", "1,99€"]
    let producerarray = ["1,5L", "1L", "1L", "250g", "250g",]
    let sizearray = [""]
    
    let filterarray = ["Lebensmittel", "Getränke", "Haushaltswaren", "Süßwaren", "Spielzeug", "Schreibwaren"]
    
    
    
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
                
        let addViewSwiftUI = AddView()
        let hostingcontroller = UIHostingController(rootView: addViewSwiftUI)
        
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
        return searcharray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tablecell.identifier, for: indexPath) as! tablecell
        
        cell.configure(productname: searcharray[indexPath.row], price: pricearray[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        let vc = LookUpVC()
        
        navigationController?.pushViewController(vc, animated: true)
        
        vc.title = array[indexPath.row]
         
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
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 80)
        
    }*/
    
}




class filterCell: UICollectionViewCell
{
    //TODO: Color Change
    
    static let identifier = "filterCell"
    var tapped = false
    
    private lazy var textView: UILabel =
    {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints  = false
        text.font = .boldSystemFont(ofSize: 13)
        text.textColor = .white
        return text
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemBlue
        
        contentView.sizeToFit()
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected()
    {
        tapped.toggle()
        
        if(tapped == true)
        {
            contentView.backgroundColor = .systemGreen
        }
        else
        {
            contentView.backgroundColor = .systemBlue
        }
    }
    
    func configure(productcategory: String)
    {
        textView.text = productcategory
    }
    
    func setupView()
    {
        contentView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
        
    }
    
    

    
}



class tablecell: UITableViewCell
{
    
    static let identifier = "cell"
    
    let productimage: UIImageView =
    {
        let i = UIImageView()
        i.sizeToFit()
        i.scalesLargeContentImage = true
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = UIImage(named: "Image")
    
        
        return i
        
    }()
    
    let productname: UILabel =
    {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 18)
        
        return l
    }()
    
    let producername: UILabel =
    {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        
        return l
    }()
   
    let price: UILabel =
    {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let sizeLabel: UILabel =
    {
        let l = UILabel()
        l.text = "500g"
        l.font = UIFont.systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
    
        return l
    }()
    
    let chevronimage: UIImageView =
    {
        let u = UIImageView()
        u.image = UIImage(systemName: "chevron.right")
        u.tintColor = .black
        
        u.translatesAutoresizingMaskIntoConstraints = false
        
        return u
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(productimage)
        contentView.addSubview(productname)
        contentView.addSubview(price)
        contentView.addSubview(chevronimage)
        contentView.addSubview(producername)
        contentView.addSubview(sizeLabel)
        
        setuplayout()
        
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .quaternarySystemFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(productname: String, price: String)
    {
        //TODO: UIIMAGE implementation
        self.productname.text = productname
        self.price.text = price
        self.producername.text = "Producer"
    }
    
    func setuplayout()
    {
        NSLayoutConstraint.activate(
            [
                productimage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                productimage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                productimage.heightAnchor.constraint(equalToConstant: 50),
                productimage.widthAnchor.constraint(equalToConstant: 50),
                productname.topAnchor.constraint(equalTo: productimage.topAnchor),
                productname.leftAnchor.constraint(equalTo: productimage.rightAnchor, constant: 10),
                producername.topAnchor.constraint(equalTo: productname.bottomAnchor, constant: 1),
                producername.leftAnchor.constraint(equalTo: productname.leftAnchor),
                chevronimage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
                chevronimage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                price.rightAnchor.constraint(equalTo: chevronimage.leftAnchor, constant: -10),
                price.centerYAnchor.constraint(equalTo: chevronimage.topAnchor),
                sizeLabel.rightAnchor.constraint(equalTo: price.rightAnchor),
                sizeLabel.centerYAnchor.constraint(equalTo: chevronimage.bottomAnchor)

        ])
    }
    
    func getProductName() -> String
    {
        return productname.text ?? ""
    }
    
}



class LookUpVC: UIViewController
{
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    func configure(product: Product)
    {
        
        
    }
    
    
    
}



struct AddView: View {
    var body: some View {
        Text("Test")
    }
}
