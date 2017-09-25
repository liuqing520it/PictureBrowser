//
//  LQBrowserViewController.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//
//层次结构 : 控制器上放collectionView,cell上放scrollView,scrollView上放一张图片,图片可实现放大缩小

import UIKit

//频幕宽
let LQ_SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.width
//频幕高
let LQ_SCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.height

class LQBrowserViewController: UIViewController {
    ///图片地址集合
    var urlsArray : [URL]
    ///图片对应的 index
    var imageIndexPath : IndexPath
    
    init(_ urls : [URL] , _ indexPath : IndexPath){
        urlsArray = urls
        imageIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
        
        addSubViewAndlayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indexLable.center = CGPoint(x: view.center.x, y: 80)
    }
    
    //MARK: - 内部控制方法
    private func addSubViewAndlayout(){
        view.addSubview(collectionView)
        view.addSubview(indexLable)
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
    
    ///提示图片索引
    private lazy var indexLable : UILabel = {
       let lab = UILabel()
        lab.textColor = UIColor.white
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.sizeToFit()
        return lab
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
        cell.dismissBlock = { 
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
}
