# PictureBrowser
图片浏览器,类似微博多图浏览;点击了哪张图片就从哪张图片慢慢放大,放大到和屏幕一样;缩小同理.
![image](https://github.com/liuqing520it/PictureBrowser/raw/master/browser.gif)

## 大致实现过程(具体实现见代码)
* 弹出 需要使用自定义转场
1. 首先创建一个UIImageView加在转场containerView上 ; 创建应该由展示视图创建;
2. 获取UIImageView相对于window的坐标  坐标转换
3. 算出UIImageView最终展示的frame(图片宽度和频幕宽度相等)
4. 设置动画让UIimageView放大
5. 动画执行完之后需要移除UIImageView 并且将浏览器添加到转场的containerView上

### 改进方向:
1. 增加横竖屏适配;
2. 添加swipe手势使手指往下扫动缩小直至消失;
