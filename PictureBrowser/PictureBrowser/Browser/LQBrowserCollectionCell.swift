//
//  LQBrowserCollectionCell.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit
import Kingfisher

protocol LQBrowserCollectionCellDelegate : NSObjectProtocol {
    
    func browserDismiss(_ browser: LQBrowserCollectionCell)
    
    func browserAction(_ browser : LQBrowserCollectionCell ,_ saveImage : UIImage)
}

class LQBrowserCollectionCell: UICollectionViewCell {
    
    var imageUrl : URL? {
        didSet{
            
            resetScrollViewSomeSet()
            
            showImageView.kf.setImage(with: imageUrl) { (image, error, _, _) in
                if error == nil{
                    //计算图片要显示的高度
                    let imageHeight = (image?.size.height)! * LQ_SCREEN_WIDTH / (image?.size.width)!
                   
                    //设置图片的frame
                    self.showImageView.frame = CGRect(x: 0, y: 0, width: LQ_SCREEN_WIDTH, height: imageHeight)
                    
                    if imageHeight <= LQ_SCREEN_HEIGHT{
                        //计算图片的偏移量
                        let imageOffset = (LQ_SCREEN_HEIGHT - imageHeight) * 0.5
                        //设置scrollView的偏移量
                        self.scrollView.contentInset = UIEdgeInsets(top: imageOffset, left: 0, bottom: imageOffset, right: 0)
                    }
                    else{//如果图片的高度大于频幕的高度 则设置contentsize让图片可以滚动
                        self.scrollView.contentSize = CGSize(width: LQ_SCREEN_WIDTH, height: imageHeight)
                    }
                    self.showImageView.image = image
                    
                }
            }
        }
    }
    
    ///代理
    weak var delegate : LQBrowserCollectionCellDelegate?
    
    ///初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViewAndLayout()
    }

    //MARK: - 内部控制方法
    ///添加子控制器
    private func addSubViewAndLayout(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(showImageView)
        
        //添加tap和longpress长按手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHappend))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappend))
        showImageView.addGestureRecognizer(tap)
        showImageView.addGestureRecognizer(longPress)
    }
    
    ///布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
    }
    
    private func resetScrollViewSomeSet(){
        scrollView.contentInset = .zero
        scrollView.contentSize = .zero
        scrollView.contentOffset = .zero
        showImageView.transform = .identity
    }
    
    ///手势点击方法
    ///tap手势
    @objc private func tapHappend(){
        delegate?.browserDismiss(self)
    }
    
    ///长按手势
    @objc private func longPressHappend(){
        
        guard let image = showImageView.image else {
            return
        }
        delegate?.browserAction(self, image)
    }
    
    //MARK: - 懒加载
    private lazy var scrollView : UIScrollView = {
       let scr = UIScrollView(frame: UIScreen.main.bounds)
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        scr.delegate = self
        scr.minimumZoomScale = 0.5
        scr.maximumZoomScale = 2.0
        scr.backgroundColor = UIColor.black
        return scr
    }()
    
    fileprivate lazy var showImageView : UIImageView = {
       let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UIScrollView 代理方法
extension LQBrowserCollectionCell : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return showImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //计算偏移量
        var offsetX = (LQ_SCREEN_WIDTH - showImageView.frame.size.width) * 0.5
        var offsetY = (LQ_SCREEN_HEIGHT - showImageView.frame.size.height) * 0.5
        
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
}
