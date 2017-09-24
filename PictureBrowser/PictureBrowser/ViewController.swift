//
//  ViewController.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/24.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

let width = (UIScreen.main.bounds.width - 20) / 3.0

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(collectionView)
        
        collectionView.center = view.center
        
        configData()
    }
    
    ///准备数据
    private func configData(){
        for i in 1..<10{
            dataSource.append(String(format:"%d.png",i))
        }
        collectionView.reloadData()
    }
    
    ///数据源
    private lazy var dataSource = Array<String>()
    ///collectionView
    private lazy var collectionView : UICollectionView = {
       let collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: width * 3 + 20), collectionViewLayout: FlowLayout())
        collect.delegate = self
        collect.dataSource = self
        collect.backgroundColor = UIColor.red
        collect.register(PictureCollectionCell.self, forCellWithReuseIdentifier: "\(PictureCollectionCell.self)")
        return collect
    }()
}

//MARK: - collectionView 代理方法
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PictureCollectionCell.self)", for: indexPath) as! PictureCollectionCell
        cell.imageName = dataSource[indexPath.item]
        return cell
    }
}

//MARK: - 自定义flowlayout
class FlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        
    }
}

//MARK: - collectionViewCell
class PictureCollectionCell: UICollectionViewCell {
    //图片名字
    var imageName : String?{
        didSet{
            imageView.image = UIImage(named : imageName!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    private lazy var imageView = UIImageView()
}

