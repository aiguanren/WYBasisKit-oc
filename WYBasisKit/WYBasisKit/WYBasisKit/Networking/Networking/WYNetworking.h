//
//  WYNetworking.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/26.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class WYFileModel;

NS_ASSUME_NONNULL_BEGIN

///网络请求方式
typedef enum : NSUInteger {
    
    ///HTTP和CAHTTPS(无需额外配置  CAHTTPS：向正规CA机构购买的HTTPS服务)
    requestWayHttpAndCAHttps = 0,
    ///HTTPS单向验证(需要将一个服务端的cer文件放进工程HTTPSFiles目录下，即server.cer)
    requestWayHttpsSingleValidation,
    ///HTTPS双向验证(需要将一个服务端的cer文件与一个带密码的客户端p12文件放进工程HTTPSFiles目录下，即server.cer和client.p12)
    requestWayHttpsBothwayValidation,
    
} NetworkRequestWay;

///成功Block
typedef void (^ _Nullable Success)(id responseObject);

///失败Blcok
typedef void (^ _Nullable Failure)(NSError *error);

///上传或者下载进度Block
typedef void (^ _Nullable Progress)(NSProgress * _Nullable progress);

///返回URL的Block
typedef NSURL * _Nullable (^ _Nullable Destination)(NSURL *targetPath, NSURLResponse *response);

///下载成功的Blcok
typedef void (^ _Nullable DownLoadSuccess)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath);

@interface WYNetworking : NSObject
singletonForInterface(WYNetworking)//单例声明

/**
 *  超时时间(默认10秒)
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;


/**
 *  设置网络的请求方式(默认HTTP)
 */
@property (nonatomic, assign) NetworkRequestWay requestWay;



/**
 *  GET请求(未返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;


/**
 *  GET请求(有返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param progress   进度的回调
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure;


/**
 *  POST请求(未返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

/**
 *  POST请求(有返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param progress   进度的回调
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure;


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters fileModelArray:(NSArray <WYFileModel *>*)modelArray progress:(Progress)progress success:(Success)success failure:(Failure)failure;


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters fileModel:(WYFileModel *)fileModel progress:(Progress)progress success:(Success)success failure:(Failure)failure;


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters urlFileModelArray:(NSArray <WYFileModel *>*)modelArray progress:(Progress)progress success:(Success)success failure:(Failure)failure;


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters urlFileModel:(WYFileModel *)fileModel progress:(Progress)progress success:(Success)success failure:(Failure)failure;


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


/**
 *  下载文件(继续下载)
 *  @param downloadTask    下载任务NSURLSessionDownloadTask的实例
 */
+ (void)downloadTaskResume:(NSURLSessionDownloadTask *)downloadTask;

/**
 *  下载文件(暂停下载)
 *  @param downloadTask    下载任务NSURLSessionDownloadTask的实例
 */
+ (void)downloadTaskSuspend:(NSURLSessionDownloadTask *)downloadTask;

/**
 *  下载文件(停止下载，会释放downloadTask)
 *  @param downloadTask    下载任务NSURLSessionDownloadTask的实例
 */
+ (void)downloadTaskStop:(NSURLSessionDownloadTask *)downloadTask;


/**
 *  JSON序列化
 *
 *  @param object   需要序列化的数据
 */
+ (instancetype)JSONSerializer:(id)object;

@end

NS_ASSUME_NONNULL_END
