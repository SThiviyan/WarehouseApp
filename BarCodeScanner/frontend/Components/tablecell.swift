//
//  tablecell.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 18.03.25.
//

import UIKit

class tablecell: UITableViewCell
{
    
    static let identifier = "cell"
    
    let productimage: UIImageView =
    {
        let i = UIImageView()
        i.sizeToFit()
        i.scalesLargeContentImage = true
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = UIImage(named: "shoppingCart")
    
        
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
    
    func configure(productname: String, producername: String, productsize: String, price: String)
    {
        //TODO: UIIMAGE implementation
        self.productname.text = productname
        self.price.text = price
        self.producername.text = producername
        self.sizeLabel.text = productsize
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
