//
//  CryptoTableViewCell.swift
//  Crypto Track
//
//  Created by KhoiLe on 17/10/2021.
//

import UIKit

struct CryptoTableViewCellViewModel {
    let name: String
    let symbol: String
    let price: String
    let iconUrl: URL?
}

class CryptoTableViewCell: UITableViewCell {

    static let identifier = "CryptoTableViewCell"
    
    // Subview
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        
        let size: CGFloat = contentView.frame.height/1.1
        iconView.frame = CGRect(x: 20,
                                y: (contentView.frame.size.height - size) / 2,
                                width: size,
                                height: size)
        
        nameLabel.frame = CGRect(x: 30 + size, y: 0,
                                 width: contentView.frame.size.width/2,
                                 height: contentView.frame.size.height/2)
        
        symbolLabel.frame = CGRect(x: 30 + size, y: contentView.frame.size.height/2,
                                   width: contentView.frame.size.width/2,
                                   height: contentView.frame.size.height/2)
        
        priceLabel.frame = CGRect(x: contentView.frame.size.width/2,
                                   y: 0,
                                   width: (contentView.frame.size.width/2)-5,
                                   height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
    }
    
    // Configure
    func configure(with viewModel: CryptoTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        symbolLabel.text = viewModel.symbol
        
        if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.iconView.image = UIImage(data: data)
                    }
                }
            })
            
            task.resume()
        }
    }

}
