//
//  ViewController.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/24.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit
import Kingfisher

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
        
        /**
         ▿ 0 : http://wx3.sinaimg.cn/bmiddle/70be0b0cgy1fjvrm8klvoj21kw11x1l2.jpg
         ▿ 1 : http://wx3.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmbpvk8j20zw23de81.jpg
         ▿ 2 : http://wx1.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmk0c7jj21kw11xhdw.jpg
         ▿ 3 : http://wx3.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmmrboij21kw11x4qu.jpg
         ▿ 4 : http://wx2.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmpb2o3j20zw0zwn05.jpg
         ▿ 5 : http://wx4.sinaimg.cn/bmiddle/70be0b0cgy1fjvrn0h36fj21kw11x1l1.jpg
         
         ▿ 0 : http://wx2.sinaimg.cn/bmiddle/75b52ed2ly1fjvohk08w0j20hd0dnq4g.jpg
         ▿ 1 : http://wx4.sinaimg.cn/bmiddle/75b52ed2ly1fjvohmhaxrj20c80l675o.jpg
         ▿ 2 : http://wx4.sinaimg.cn/bmiddle/75b52ed2ly1fjvohqgnixj20go08xmzk.jpg
         ▿ 3 : http://wx3.sinaimg.cn/bmiddle/75b52ed2ly1fjvohs1o88j20j60ee42l.jpg
         ▿ 4 : http://wx4.sinaimg.cn/bmiddle/75b52ed2ly1fjvohtknzgj20dw0ht77k.jpg
         */
        let arr = ["http://wx3.sinaimg.cn/bmiddle/70be0b0cgy1fjvrm8klvoj21kw11x1l2.jpg",
                   "http://wx3.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmbpvk8j20zw23de81.jpg",
                   "http://wx1.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmk0c7jj21kw11xhdw.jpg",
                   "http://wx3.sinaimg.cn/bmiddle/70be0b0cgy1fjvrmmrboij21kw11x4qu.jpg",
                   "http://wx4.sinaimg.cn/bmiddle/75b52ed2ly1fjvohtknzgj20dw0ht77k.jpg",
                   "http://wx4.sinaimg.cn/bmiddle/70be0b0cgy1fjvrn0h36fj21kw11x1l1.jpg",
                   "http://wx4.sinaimg.cn/bmiddle/75b52ed2ly1fjvohmhaxrj20c80l675o.jpg",
                   "http://wx4.sinaimg.cn/bmiddle/75b52ed2ly1fjvohqgnixj20go08xmzk.jpg",
                   "http://wx3.sinaimg.cn/bmiddle/75b52ed2ly1fjvohs1o88j20j60ee42l.jpg"]
        
        
        
        for i in 0..<arr.count{
            let url = URL.init(string: arr[i])
            dataSource.append(url!)
        }
        
        collectionView.reloadData()
    }
    
    ///数据源
    private lazy var dataSource = Array<URL>()
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
        cell.imageView.kf.setImage(with: dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browserVC = LQBrowserViewController.init(dataSource, indexPath)
        present(browserVC, animated: true, completion: nil)
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
    
    fileprivate lazy var imageView = UIImageView()
}

