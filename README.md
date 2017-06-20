# UIViewController-WBSKD
UIViewController+WBSKD

微博sdk 登录bug 
情景： 当用户未安装微博客户端时，点击微博登录需要弹出webview 进行登录，微博sdk 存在bug，第一次点击无法进入web页面，或者web页面加载到非rootvc 上，点击第二次时才会显示在window.rootvc上。

引入头文件到微博登录的vc中即可。
