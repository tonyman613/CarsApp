//
//  CarsCollectionViewCell.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/21/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CarsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var myCarsImageView: UIImageView!
    @IBOutlet var ownerLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
        override init(frame: CGRect) {
            super.init(frame: frame)
        
        // Should use Auto layout and set constrainsts, Only good for iphone 6 right now.
//        myCarsImageView = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width, height: frame.size.height*2/3))
        myCarsImageView = UIImageView(frame: CGRect(x: 0, y: 15, width: 180, height: 140))
        myCarsImageView.contentMode = UIViewContentMode.ScaleToFill
        contentView.addSubview(myCarsImageView)

        let textFrame = CGRect(x: 5, y: 125, width: frame.size.width, height: frame.size.height/2)
        ownerLabel = UILabel(frame: textFrame)
        ownerLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        ownerLabel.textAlignment = .Center
        contentView.addSubview(ownerLabel)
    }
//
//
//    let textLabel: UILabel!
//    let imageView: UIImageView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width, height: frame.size.height*2/3))
//        imageView.contentMode = UIViewContentMode.ScaleAspectFill
//        contentView.addSubview(imageView)
//        
//        let textFrame = CGRect(x: 0, y: 90, width: frame.size.width, height: frame.size.height/2)
//        textLabel = UILabel(frame: textFrame)
//        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        textLabel.textAlignment = .Center
//        contentView.addSubview(textLabel)
//    }
    
}
