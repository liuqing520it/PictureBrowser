//
//  LQBrowserCollectionCell.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class LQBrowserCollectionCell: UICollectionViewCell {
    
    var imageUrl : URL? {
        didSet{
                
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViewAndLayot()
    }

    //MARK: - 内部控制方法
    private func addSubViewAndLayot(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(showImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        showImageView.frame = scrollView.frame
    }
    
    //MARK: - 懒加载
    private lazy var scrollView : UIScrollView = {
       let scr = UIScrollView(frame: UIScreen.main.bounds)
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        scr.delegate = self
        scr.minimumZoomScale = 0.5
        scr.maximumZoomScale = 2.0
        return scr
    }()
    
    fileprivate lazy var showImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LQBrowserCollectionCell : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return showImageView
    }
}
