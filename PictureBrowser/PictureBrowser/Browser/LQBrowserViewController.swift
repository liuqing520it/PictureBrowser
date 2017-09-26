//
//  LQBrowserViewController.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//
//层次结构 : 控制器上放collectionView,cell上放scrollView,scrollView上放一张图片,图片可实现放大缩小

import UIKit
import Photos
//频幕宽
let LQ_SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.width
//频幕高
let LQ_SCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.height

class LQBrowserViewController: UIViewController {
    ///图片地址集合
    var urlsArray : [URL]
    ///图片对应的 index
    var imageIndexPath : IndexPath
    
    //重写init方法
    init(_ urls : [URL] , _ indexPath : IndexPath){
        urlsArray = urls
        imageIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
        
        addSubViewAndlayout()
        
        pageControl.numberOfPages = urls.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.scrollToItem(at: imageIndexPath, at: .left, animated: false)
        
        pageControl.currentPage = imageIndexPath.item
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        collectionView.scrollToItem(at: imageIndexPath, at: .left, animated: false)
//    }
//
    //MARK: - 内部控制方法
    private func addSubViewAndlayout(){
        view.addSubview(collectionView)
        view.addSubview(pageControl)
    }

    //MARK: - 懒加载
    ///collectionView
    private lazy var collectionView : UICollectionView = {
       let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.register(LQBrowserCollectionCell.self, forCellWithReuseIdentifier: "\(LQBrowserCollectionCell.self)")
        collection.backgroundColor = UIColor.white
        return collection
    }()
    ///自定义布局
    private lazy var flowLayout : UICollectionViewFlowLayout = {
        let fly = UICollectionViewFlowLayout()
        fly.itemSize = UIScreen.main.bounds.size
        fly.minimumInteritemSpacing = 0
        fly.minimumLineSpacing = 0
        fly.sectionInset = UIEdgeInsets.zero
        fly.scrollDirection = .horizontal
        return fly
    }()
    
    ///指示器
    fileprivate lazy var pageControl : UIPageControl = {
       let page = UIPageControl(frame: CGRect(x: 0, y: LQ_SCREEN_HEIGHT - 49, width: LQ_SCREEN_WIDTH, height: 49))
        page.hidesForSinglePage = true
        page.currentPageIndicatorTintColor = UIColor.white
        page.pageIndicatorTintColor = UIColor.init(white: 0.6, alpha: 0.6)
        return page
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - collectionView代理方法和数据源方法
extension LQBrowserViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(LQBrowserCollectionCell.self)", for: indexPath) as! LQBrowserCollectionCell
        cell.imageUrl = urlsArray[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / LQ_SCREEN_WIDTH)
    }
}

//MARK: - cell 的代理方法
extension LQBrowserViewController: LQBrowserCollectionCellDelegate{
    //弹出选择菜单
    func browserAction(_ browser : LQBrowserCollectionCell ,_ saveImage : UIImage){
        altertActionSheet(saveImage)
    }
    
    //dismiss
    func browserDismiss(_ browser: LQBrowserCollectionCell) {
        dismiss(animated: true, completion: nil)
    }
    
    private func altertActionSheet(_ saveImage : UIImage){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { (_) in
            //写入相册
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: saveImage)
            }, completionHandler: { (_, error) in
                if error != nil{
                    print(error as Any)
                }
            })
        }
        saveAction.setValue(UIColor.blue, forKey: "titleTextColor")
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveAction)
        present(alertVC, animated: true, completion: nil)
    }
}
