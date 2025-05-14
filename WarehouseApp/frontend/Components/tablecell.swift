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
    
    var product: Product
    
    let productimage: UIImageView =
    {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.translatesAutoresizingMaskIntoConstraints = false
        
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
        l.font = UIFont.systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
    
        return l
    }()
    
    let chevronimage: UIImageView =
    {
        let u = UIImageView()
        u.image = UIImage(systemName: "chevron.right")
        u.tintColor = .placeholderText
        
        u.translatesAutoresizingMaskIntoConstraints = false
        
        return u
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.product = Product()
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productimage.image = UIImage(named: "shoppingCart")
    }
    
    func configure(product: Product, img: UIImage?)
    {
        self.product = product
        
        //TODO: UIIMAGE implementation
        self.productname.text = self.product.productname
        self.price.text = String(format: "%.2f",self.product.price ?? "")
        self.producername.text = self.product.producer
        self.sizeLabel.text = String(format: "%.2f", self.product.size ?? "")
        
        self.productimage.image = img ?? UIImage(named: "shoppingCart")
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
    
    func getProduct() -> Product
    {
        return product
    }
    
}
