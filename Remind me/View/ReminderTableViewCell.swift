//
//  ReminderTableViewCell.swift
//  Remind me
//
//  Created by Jari Koopman on 30/09/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 15, y: 7.5, width: 29, height: 29))
        imageView.image = UIImage(named: "location")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 58, y: 5, width: 42, height: 20))
        label.text = "test"
        
        return label
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 59, y: 26, width: 33, height: 14))
        label.textColor = UIColor(red: 143/255, green: 142/255, blue: 148/255, alpha: 1)
        label.text = "test 2"
        
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.addSubview(locationImageView)
        self.addSubview(titleLabel)
        self.addSubview(subLabel)
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationImageView.heightAnchor.constraint(equalToConstant: 29),
            locationImageView.widthAnchor.constraint(equalToConstant: 29),
            locationImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            locationImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 14),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            subLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 14),
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            subLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
