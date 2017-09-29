//
//  LQTableViewCell.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/26.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit
import Kingfisher

class LQCollectionViewCell : UICollectionViewCell {
    
    var imageUrl : URL?{
        didSet{
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    //布局子控件
    lazy var imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

