# WYBasisKit(持续更新)

## 安装使用
直接复制“WYBasisKit”到项目中，在需要使用的地方引入“GlobalHeader.pch”头文件(后续会添加cocoapods支持)。

## "WYBasisKit"是做什么的?

"WYBasisKit" 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。


### [点这里穿越到Swift版](https://github.com/Jacke-xu/WYBasisKit-swift.git)


## "WYBasisKit"目录介绍
```
WYBasisKit/AppleSystemService  :  苹果外链方法，如拨打电话、跳转app评论页;
WYBasisKit/BoolJudge           :  使用正则及系统API实现BOOL判断并返回BOOL值，如判断是否有定位权限、是否为身份证号、是否是银行卡号等;
WYBasisKit/CNLog               :  中文日志打印(不用自己任何处理，放进项目中就行);
WYBasisKit/Countdown           :  倒计时相应功能;
WYBasisKit/Encryption          :  各种加密技术，如RSA、AES、DES、MD5;
WYBasisKit/Layout              :  布局框架拓展，如UIView、UIButton、UITextView、UITextField、UILable等;
WYBasisKit/LoadingState        :  各种弹窗，网络等待弹窗及状态(成功、失败、警告)弹窗;
WYBasisKit/MacroDefinition     :  各种宏定义;
WYBasisKit/Memory              :  基于NSUserDefaults实现的本地存储;
WYBasisKit/Networking          :  网络请求相关，基于AFNetworking封装的网络请求API、基于系统方法封装的网络解析类、基于苹果方法封装的网络连接判断(可弹窗提示，极易使用);
WYBasisKit/Practical           :  实用类拓展，如UIImage、UIColor、UIViewController、UINavigationController等;
WYBasisKit/RefreshView         :  基于MJRefresh刷新框架的封装，可以快速构建实例对象;
WYBasisKit/Libraries           :  自己写的一些小第三方，如不用可直接删除;
```

## If you think it's cool,Please give me a little star. (如果你也觉得很酷😎，就点一下Star吧(●ˇ∀ˇ●))

### UINavigationController+Extension
```
1.可以通过属性直接设置导航栏(navigationBar)
2.可以监听、拦截到导航栏的手势返回事件
```
```
//设置标题颜色
self.navigationController.titleColor = [UIColor yellowColor];
//设置标题字号
self.navigationController.titleFont = [UIFont boldSystemFontOfSize:20];
//设置导航栏背景图
self.navigationController.barBackgroundImage = [UIImage imageNamed:@"test"];
//设置导航栏背景颜色(设置了背景图就不用设置背景颜色了)
//self.navigationController.barBackgroundColor = [UIColor greenColor];
//设置导航栏返回按钮图片
self.navigationController.barReturnButtonImage = [UIImage imageNamed:@"返回按钮"];
//设置导航栏返回按钮文字颜色
self.navigationController.barReturnButtonColor = [UIColor whiteColor];
//设置跳转到下一页时返回文本(可以传空)
[self.navigationController pushControllerBarReturnButtonTitle:@"上一页" navigationItem:self.navigationItem];
```
![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/navigationBar.gif)


### NSMutableAttributedString+Extension  && UILabel+RichText
```
NSMutableAttributedString+Extension
1.可以快速创建富文本属性，已有的直接就直接返回；
2.可以通过属性快速设置标签不同位置处文本的颜色和字号大小；
3.可以快速设置标签的行间距、字间距、添加下划线等等。

UILabel+RichText
1.可以通过代理或block设置标签的点击事件
2.可以设置要点击字符串的点击效果和点击效果颜色
```
```
使用方式(NSMutableAttributedString+Extension)
//快速创建富文本属性
NSMutableAttributedString *attribute = [NSMutableAttributedString attributeWithStr:lab.text];
//设置行间距
[attribute setLineSpacing:5 string:lab.text];
//设置字间距
[attribute setWordsSpacing:20 string:@"然后中和之化应"];
//通过传入要设置的文本设置文本颜色
NSArray *colorsOfRanges = @[@{[UIColor orangeColor]:@"治性之道"},@{[UIColor greenColor]:@"盖聪明疏通者戒于太察"}];
[attribute colorsOfRanges:colorsOfRanges];
//通过传入要设置的文本和传入要设置文本的下标位置综合设置文本字号
NSArray *fontsOfRanges = @[@{[UIFont systemFontOfSize:18]:@"广心浩大者戒于遗忘"},@{[UIFont boldSystemFontOfSize:30]:@[@"1",@"2"]}];
[attribute fontsOfRanges:fontsOfRanges];
//设置标签的富文本为自定义的富文本属性
lab.attributedText = attribute;

使用方式(UILabel+RichText)
//通过代理设置要点击的字符串
[label clickRichTextWithStrings:@[@"点我",@"点我"] delegate:self];
//通过block设置要点击的字符串
[label clickRichTextWithStrings:@[@"https://github.com/Jacke-xu/WYBasisKit",@"记得给star哦"] clickAction:^(NSString *string, NSRange range, NSInteger index) {
NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),(long)index];
NSLog(@"messge = %@",message);
}];
```
![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/UILable.gif)


### UITextView+Extension  && UITextField+Extension
```
1.可以快速设置占位文本及占位文本颜色
2.可以添加文字输入限制，省去自己写代理截取字符串的麻烦
3.处理系统输入法导致的乱码
```
```
//设置textView占位符
textView.placeholderStr = @"在这里设置textView的占位文本";
//让视图自动跟随键盘移动(一句话的事儿，就是这么🐂)⭐️⭐️⭐️⭐️⭐️
[textView automaticFollowKeyboard:self.view];
//设置最大输入文本限制,就是这么简单
textView.maximumLimit = 10;
//设置右下角文字提示
textView.characterLengthPrompt = YES;
```
![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/UITextField.gif) ![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/UITextView.gif)


### UIButton+Extension  && UIButton+EdgeInsetsLayout
```
1.可以通过运行时或EdgeInsets快速调整button的图片控件与文本控件的位置
2.可以快速初始化及添加点击事件
3.可以通过不同的属性快速设置button不同状态时的title、title颜色、和image
```
```
btn.nTitle = @"默认状态";
btn.hTitle = @"高亮状态";
btn.sTitle = @"选中状态";
btn.title_nColor = [UIColor greenColor];
btn.title_hColor = [UIColor yellowColor];
btn.title_sColor = [UIColor blackColor];
btn.nImage = [UIImage imageNamed:@"timg-n"];
btn.hImage = [UIImage imageNamed:@"timg-h"];
btn.sImage = [UIImage imageNamed:@"timg-s"];

//通过运行时设置图片控件与文本控件的位置
btn.titleRect = CGRectMake((btn.width-titleSize.width)/2, (btn.height-imageSize.height-titleSize.height-5)/2, titleSize.width, titleSize.height);
btn.imageRect = CGRectMake((btn.width-imageSize.width)/2, 5+titleSize.height+((btn.height-imageSize.height-titleSize.height-5)/2), imageSize.width, imageSize.height);

//通过EdgeInsets设置图片控件与文本控件的位置
[btn2 layouEdgeInsetsPosition:ButtonPositionImageTop_titleBottom spacing:5];
```
![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/UIButton.gif) 


### WKWebView+Extension
```
只需一行代码就可以给WKWebView添加进度监听(进度条)，并且可以设置进度条颜色
```
```
//使用示例
WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navViewHeight)];
[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com/cn/"]]];
//看这里，看这里，一行代码就实现了进度监听和进度条颜色自定义
[webView showProgressWithColor:[UIColor orangeColor]];
[self.view addSubview:webView];
```
![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/webView.gif) 


### StateView  && LoadingView
```
//StateView
/** 提示成功信息 */
+ (void)showSuccessInfo:(NSString *)info;

/** 提示错误信息 */
+ (void)showErrorInfo:(NSString *)info;

/** 提示警告信息 */
+ (void)showWarningInfo:(NSString *)info;

/** 自定义图片模式 */
+ (void)showMessage:(NSString *)message;

//LoadingView
/** 自定义图片模式  superView只能是控制器view或则keyWindow */
+ (void)showMessage:(NSString *)message superView:(UIView *)superView;

/** 系统小菊花模式 */
+ (void)showInfo:(NSString *)info;

/** 系统小菊花模式  superView只能是控制器view或则keyWindow */
+ (void)showInfo:(NSString *)info  superView:(UIView *)superView;


//通用
/** 移除弹窗 */
+ (void)dismiss;

/** 弹窗时是否允许用户界面交互  默认允许 */
+ (void)userInteractionEnabled:(BOOL)userInteractionEnabled;
```
![image](https://github.com/Jacke-xu/WYBasisKit/blob/master/GitResource/LoadingState.gif) 


### 基于AFNetworking封装的网络请求(支持HTTPS)
```
///HTTP和CAHTTPS(无需额外配置  CAHTTPS：向正规CA机构购买的HTTPS服务)
requestWayHttpAndCAHttps = 0,
///HTTPS单向验证(需要将一个服务端的cer文件放进工程HTTPSFiles目录下，即server.cer)
requestWayHttpsSingleValidation,
///HTTPS双向验证(需要将一个服务端的cer文件与一个带密码的客户端p12文件放进工程HTTPSFiles目录下，即server.cer和client.p12)
requestWayHttpsBothwayValidation,

/**
*  超时时间(默认10秒)
*/
@property (nonatomic, assign) NSTimeInterval timeoutInterval;


/**
*  设置网络的请求方式(默认HTTP)
*/
@property (nonatomic, assign) NetworkRequestWay requestWay;

/**
*  GET请求
*
*  @param URLString  请求的链接
*  @param parameters 请求的参数
*  @param success    请求成功回调
*  @param failure    请求失败回调
*/
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

/**
*  POST请求
*
*  @param URLString  请求的链接
*  @param parameters 请求的参数
*  @param success    请求成功回调
*  @param failure    请求失败回调
*/
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

/**
*  POST单个文件上传(如图片、MP3、MP4等)
*
*  @param URLString    请求的链接
*  @param parameters   请求的参数
*  @param fileModel    待上传文件的模型
*  @param progress     进度的回调
*  @param success      上传成功的回调
*  @param failure      上传失败的回调
*/
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters fileModel:(WYFileModel *)fileModel progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
*  POST多个文件上传(如图片、MP3、MP4等)
*
*  @param URLString    请求的链接
*  @param parameters   请求的参数
*  @param modelArray   存放待上传文件模型的数组
*  @param progress     进度的回调
*  @param success      上传成功的回调
*  @param failure      上传失败的回调
*/
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters fileModelArray:(NSArray <WYFileModel *>*)modelArray progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
*  POST多个URL资源上传(根据本地文件URL路径上传图片、MP3、MP4等)
*
*  @param URLString        请求的链接
*  @param parameters       请求的参数
*  @param modelArray       存放待上传文件模型的数组
*  @param progress         进度的回调
*  @param success          上传成功的回调
*  @param failure          上传失败的回调
*/
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters urlFileModelArray:(NSArray <WYFileModel *>*)modelArray progress:(Progress)progress success:(Success)success failure:(Failure)failure;


/**
*  POST单个URL资源上传(根据本地文件URL路径上传图片、MP3、MP4等)
*
*  @param URLString        请求的链接
*  @param parameters       请求的参数
*  @param fileModel        上传的文件模型
*  @param progress         进度的回调
*  @param success          上传成功的回调
*  @param failure          上传失败的回调
*/
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters urlFileModel:(WYFileModel *)fileModel progress:(Progress)progress success:(Success)success failure:(Failure)failure;

/**
*  下载文件
*
*  @param URLString   请求的链接
*  @param filePath    文件存储目录(默认存储目录为Download)
*  @param progress    进度的回调
*  @param success     下载成功的回调
*  @param failure     下载失败的回调
*
*  返回NSURLSessionDownloadTask实例，可用于暂停下载、继续下载、停止下载，暂停调用suspend方法，继续下载调用resume方法
*/
- (NSURLSessionDownloadTask *)downLoadWithURL:(NSString *)URLString fileSavePath:(NSString *)filePath progress:(Progress)progress success:(DownLoadSuccess)success failure:(Failure)failure;
```


如您在使用过程中发现BUG,或有好的意见建议，可发邮件至aiguanren@icloud.com
