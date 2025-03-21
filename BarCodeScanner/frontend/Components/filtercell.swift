//
//  filtercell.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 18.03.25.
//

import UIKit

class filterCell: UICollectionViewCell
{
    //TODO: Color Change
    
    static let identifier = "filterCell"
    var tapped = false
    
    private lazy var textView: UILabel =
    {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints  = false
        text.font = .boldSystemFont(ofSize: 14)
        text.textColor = .white
        return text
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
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
            contentView.backgroundColor = .systemBlue.withAlphaComponent(1)
        }
        else
        {
            contentView.backgroundColor = .systemBlue.withAlphaComponent(0.5)
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

