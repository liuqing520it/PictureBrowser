//
//  LQBrowserManager.swift
//  PictureBrowser
//
//  Created by liuqing on 2017/9/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//
// 点击一张图片从那张图片慢慢放大弹出, 实现原理: 自定义转场后有一个空的view盖在了window上 视图需要手动添加
//1. 首先创建一个UIImageView, 加在转场containerView上 ; 创建应该由展示视图创建,可以拿到它要展示的image
//2. 获取UIImageView相对于window的坐标  坐标转换
//3. 算出UIImageView最终展示的frame
//4. 设置动画让UIimageView放大
//5. 动画执行完之后需要移除UIImageView 并且将浏览器添加到转场的containerView上

import UIKit
import Kingfisher

protocol LQBrowserManagerDelegate : NSObjectProtocol {
    ///创建ImageView
    func browserManagerCreateImageView(_ manager : LQBrowserManager ,_ imageIndex : IndexPath) -> UIImageView
    ///获取图片在window上的坐标
    func browserManagerWillShow(_ manager : LQBrowserManager , _ imageIndex : IndexPath) -> CGRect
    ///获取图片的最终坐标
    func browserManagerDidShow(_ manager : LQBrowserManager, _ imageIndex : IndexPath) -> CGRect
}

class LQBrowserManager: NSObject , UIViewControllerTransitioningDelegate{

    ///记录是弹出还是消失
    fileprivate var isPresent : Bool = false
    ///图片对应的索引
    fileprivate var imageIndexPath : IndexPath = []
    //代理 用来传值
    fileprivate weak var delegate : LQBrowserManagerDelegate?
    
    ///设置图片索引 和 代理
    func browserManager(_ indexPath: IndexPath ,_ delegate : LQBrowserManagerDelegate){
        imageIndexPath = indexPath
        self.delegate = delegate
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    //下面两个方法 设置 UIViewControllerAnimatedTransitioning的代理
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        return self
    }
    
    ///计算图片的最终展示大小
    func calculateDidShowImageFrame(_ cacheUrl : URL) -> CGRect{
        
        guard let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: (cacheUrl.absoluteString))else{
            return .zero
        }
        
        let imageHeight = image.size.height / image.size.width * LQ_SCREEN_WIDTH
        
        let offsetY = imageHeight > LQ_SCREEN_HEIGHT ? 0 : (LQ_SCREEN_HEIGHT - imageHeight) * 0.5
        
        return CGRect(x: 0, y: offsetY, width: LQ_SCREEN_WIDTH, height: imageHeight)
    }
    
    
}

//MARK: - <UIViewControllerAnimatedTransitioning>
extension LQBrowserManager : UIViewControllerAnimatedTransitioning{
    ///设置转场时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    //管理弹出和消失
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        
        if isPresent{//弹出
            ///设置容器视图的背景颜色为黑色
            transitionContext.containerView.backgroundColor = UIColor.black
            
            willPresentedController(transitionContext)
        }
        else{//消失
            ///设置容器视图的背景颜色为透明
            transitionContext.containerView.backgroundColor = UIColor.clear
            
            willDismissedController(transitionContext)
        }
    }
    
    ///弹出
     private func willPresentedController(_ transitionContext: UIViewControllerContextTransitioning){
        
        //获取弹出视图的view
        guard let toView = transitionContext.view(forKey:.to)else{
            return
        }
        
        //1.创建UIimageView 展示图片
        guard let maskImageView = delegate?.browserManagerCreateImageView(self, imageIndexPath) else{
            return
        }
        
        //2.获取图片要展示在window的frame
        guard let imageFrame = delegate?.browserManagerWillShow(self, imageIndexPath)else{
            return
        }
        //2.1 设置覆盖imageView的frame
        maskImageView.frame = imageFrame
        //2.2 将覆盖imageView添加到转场 containerView 上
        transitionContext.containerView.addSubview(maskImageView)
        
        //3.获取图片最终显示出来的frame
        guard let resultFrame = delegate?.browserManagerDidShow(self, imageIndexPath) else{
            return
        }
        //4.执行动画 让图片逐渐放大
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            maskImageView.frame = resultFrame
        }) { (_) in
            //5. 动画执行完后将 imageView移除
            maskImageView.removeFromSuperview()
            //5.1 浏览器添加到containerView上
            transitionContext.containerView.addSubview(toView)
            //5.2 这句非常重要  需要告诉上下文转场动画执行完毕了
            transitionContext.completeTransition(true)
        }
    }
    
    ///消失
    private func willDismissedController(_ transitionContext: UIViewControllerContextTransitioning){
        guard let formVC = transitionContext.viewController(forKey: .from) as? LQBrowserViewController else{
            return
        }
        
        formVC.view.removeFromSuperview()
        //1. 新建一个imagView 图片的frame 刚好覆盖当前展示的图片
        guard let maskImageView = formVC.createImageView(formVC.imageIndexPath)else{
            return
        }
        transitionContext.containerView.addSubview(maskImageView)
        
        //2. 找到这张图片 在collectionView 对应的坐标
        guard let scaleFrame = delegate?.browserManagerWillShow(self, formVC.imageIndexPath)else{
            return
        }
        //3. 执行动画 让图片逐渐缩小
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            maskImageView.frame = scaleFrame
            
        }) { (_) in
            maskImageView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
}
