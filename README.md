# iconMaker
一款Mac终端命令行工具,用来自动生成iOS应用图标

事情是这样的,每次在更换APP图标的时候,UI切图人员给的图标大大小小的一堆,不知道哪个放哪个位置...总感觉特别繁琐,或者说不够规范,我每次都是去[图标工厂](https://icon.wuruihong.com/#/ios)上传一个1024x1024的图标,然后将下载下来的AppIcon.appiconset文件整体替换项目中的这个文件就完事了...这个过程感觉清爽多了

后来我就在想,他们网页可以通过上传一张图片,然后提供给我们一份准备好的文件...为什么我不可以自己写一个程序用来做这件事儿,不是说别人的网页不够好,而是想要去尝试一下看看自己一个iOS开发能不能做这个事儿...事实证明也是可以的,一开始我是开发了一个iOS项目来做这个事儿,1024的图标都是放在项目中的,然后在桌面输出一个文件夹,里面有切好的图标;这样一来每次都得启动一个iOS模拟器,挺麻烦的,也不够清爽...后来就想应该不需要使用iOS项目也能完成这个事儿,于是就想到了开发一个MacOS上的CommandLineTool来完成,其中还是遇到了不少问题的,比如之前对图片的处理都是通过UIKit框架提供的方法来绘制不同尺寸的图片的;而到这个这个命令行程序中,发现无法导入UIKit框架...只能导入APPKit框架...然后想到APPKit里面应该也有处理图片的函数或方法,于是开始了搜索之旅,经过一番搜寻代码,修修改改之后,终于完成了...

使用方法一:
![](https://raw.githubusercontent.com/masterKing/markDownPictures/master/Snip20180906_42.png)
上图步骤完了以后,直接 command + R 运行工程,桌面就会多一个ApppIcon.appiconset文件夹,这种方法的缺点是每次都需要打开项目,修改启动参数

使用方法二:

git clone下来代码之后,build编译一次后,在Products文件夹下就会生成下图所示的程序
![](https://raw.githubusercontent.com/masterKing/markDownPictures/master/Snip20180906_43.png)
在Finder中打开之后,把该程序拖到你常用的文件下,这里就做个演示拖到桌面,然后在终端中执行,如下图所示:
![](https://raw.githubusercontent.com/masterKing/markDownPictures/master/Snip20180906_47.png)
如果图片没有什么问题,那么回车后就可以在桌面看到一个ApppIcon.appiconset文件夹了


其实查看源代码就会知道,这是一个很简单的小程序而已...没有什么了不起的,我做iOS开发也有一段日子了,每天都是从接口拉数据,铺界面,感觉代码并不能为我做什么事情...只是看到网页能够输入一张图片,输出包含一堆图片的文件夹后才想到原来我们iOS开发也能够做一些输入输出,而不仅仅是在iPhone上搭一些界面...
