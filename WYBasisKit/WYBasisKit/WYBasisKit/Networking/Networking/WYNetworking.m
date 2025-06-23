//
//  WYNetworking.m
//  WYBasisKit
//
//  Created by  guanren on 2018/6/26.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "WYNetworking.h"
#import "AFNetworking.h"
#import "WYFileModel.h"
#import "StateView.h"

@implementation WYNetworking
singletonForImplementation(WYNetworking)//单例实现

/**
 *  GET请求(未返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] GET:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {success(responseObject);}
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {failure(error);}
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
}


/**
 *  GET请求(有返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param progress   进度的回调
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] GET:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if(progress) {progress(downloadProgress);}
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


/**
 *  POST请求(未返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] POST:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

/**
 *  POST请求(有返回请求进度)
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param progress   进度的回调
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] POST:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(progress) {progress(uploadProgress);}
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters fileModelArray:(NSArray<WYFileModel *> *)modelArray progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] POST:URLString parameters:parameters headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < modelArray.count; i++)
        {
            @autoreleasepool {
                
                WYFileModel *fileModel = modelArray[i];
                [formData appendPartWithFileData:fileModel.fileData name:fileModel.fileName fileName:fileModel.fileName mimeType:fileModel.mimeType];
                fileModel.fileData = nil;
                fileModel = nil;
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(progress) {progress(uploadProgress);}
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters fileModel:(WYFileModel *)fileModel progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] POST:URLString parameters:parameters headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileModel.fileData name:fileModel.folderName fileName:fileModel.fileName mimeType:fileModel.mimeType];
        fileModel.fileData = nil;
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(progress) {progress(uploadProgress);}
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


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
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters urlFileModelArray:(NSArray <WYFileModel *>*)modelArray progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] POST:URLString parameters:parameters headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < modelArray.count; i++)
        {
            @autoreleasepool {
                
                WYFileModel *fileModel = modelArray[i];
                //根据本地路径获取url(相册等资源上传)
                NSURL *fileUrl = [NSURL fileURLWithPath:fileModel.fileUrl];
                [formData appendPartWithFileURL:fileUrl name:fileModel.fileName fileName:fileModel.fileName mimeType:fileModel.mimeType error:nil];
                fileModel = nil;
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(progress) {progress(uploadProgress);}
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


/**
 *  POST单个URL资源上传(根据本地文件URL路径上传图片、MP3、MP4等)
 *
 *  @param URLString        请求的链接
 *  @param parameters       请求的参数
 *  @param fileModel        上传的图片模型
 *  @param progress         进度的回调
 *  @param success          上传成功的回调
 *  @param failure          上传失败的回调
 */
- (void)POST:(NSString *)URLString headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters urlFileModel:(WYFileModel *)fileModel progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    [[self sharedSessionManager] POST:URLString parameters:parameters headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //根据本地路径获取url(相册等资源上传)
        NSURL *fileUrl = [NSURL fileURLWithPath:fileModel.fileUrl];
        [formData appendPartWithFileURL:fileUrl name:fileModel.fileName fileName:fileModel.fileName mimeType:fileModel.mimeType error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(progress) {progress(uploadProgress);}
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {success(responseObject);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {failure(error);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


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
- (NSURLSessionDownloadTask *)downLoadWithURL:(NSString *)URLString fileSavePath:(NSString *)filePath progress:(Progress)progress success:(DownLoadSuccess)success failure:(Failure)failure {
    
    [self networkMonitoring:^(BOOL hasNetwork) {if(hasNetwork == NO) {return;}}];
    
    // 下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 temp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downloadTask = [[self sharedSessionManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {progress(downloadProgress);}
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:filePath.length > 0 ? filePath : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadPath stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {failure(error);}
        else {success(response, filePath);}
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    //开始启动任务
    [downloadTask resume];
    
    return downloadTask;
}


/**
 *  下载文件(继续下载)
 *  @param downloadTask    下载任务NSURLSessionDownloadTask的实例
 */
+ (void)downloadTaskResume:(NSURLSessionDownloadTask *)downloadTask {
    
    [downloadTask resume];
}

/**
 *  下载文件(暂停下载)
 *  @param downloadTask    下载任务NSURLSessionDownloadTask的实例
 */
+ (void)downloadTaskSuspend:(NSURLSessionDownloadTask *)downloadTask {
    
    [downloadTask suspend];
}

/**
 *  下载文件(停止下载，会释放downloadTask)
 *  @param downloadTask    下载任务NSURLSessionDownloadTask的实例
 */
+ (void)downloadTaskStop:(NSURLSessionDownloadTask *)downloadTask {
    
    [downloadTask suspend];
    downloadTask = nil;
}


/**
 *  JSON序列化
 *
 *  @param object   需要序列化的数据
 */
+ (instancetype)JSONSerializer:(id)object {
    
    return [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
}


/**
 *  判断网络连接状况
 */
- (void)networkMonitoring:(void(^)(BOOL hasNetwork))networkBlock {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if((status == AFNetworkReachabilityStatusNotReachable) && (networkBlock)) {
            
            networkBlock(NO);
            [StateView showWarningInfo:@"无网络连接,请检查您的网络设置!"];
        }
    }];
}


/**
 *  设置安全策略
 */
- (AFSecurityPolicy *)securityPolicy {
    
    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    if(certFilePath.length == 0) {NSLog(@"server.cer文件没找到");}
    
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    NSSet *certSet = [NSSet setWithObject:certData];
    
    /*
     AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
     AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
     AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
     */
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    securityPolicy.allowInvalidCertificates = YES;//使用自建证书  默认NO
    securityPolicy.validatesDomainName = YES;//域名验证  默认YES
    
    if(_requestWay == requestWayHttpsBothwayValidation) {
        
        __weak AFHTTPSessionManager *manager = [self sharedSessionManager];
        __weak typeof(self)weakSelf = self;
        
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential =nil;
            if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                if([manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if(credential) {
                        disposition =NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                //client authentication
                SecIdentityRef identity = NULL;
                SecTrustRef trust = NULL;
                NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client"ofType:@"p12"];
                NSFileManager *fileManager =[NSFileManager defaultManager];
                if(![fileManager fileExistsAtPath:p12]) {NSLog(@"client.p12文件没找到");}
                else {
                    
                    NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                    
                    if ([[weakSelf class]extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
                    {
                        SecCertificateRef certificate = NULL;
                        SecIdentityCopyCertificate(identity, &certificate);
                        const void*certs[] = {certificate};
                        CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                        credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                        disposition =NSURLSessionAuthChallengeUseCredential;
                    }
                }
            }
            *_credential = credential;
            return disposition;
        }];
    }
    return securityPolicy;
}

/**
 *  验证P12文件
 */
- (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSString *clientPwd = @"";//请在此处补全p12文件密码
    if(clientPwd.length == 0) {NSLog(@"请补全p12文件密码");}
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:clientPwd
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"p12文件验证失败 code %d",(int)securityError);
        return NO;
    }
    return YES;
}

#pragma mark 构造方法

static AFHTTPSessionManager *_manager = nil;
- (AFHTTPSessionManager *)sharedSessionManager {
    
    __weak typeof(self)weakSelf = self;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        _manager = [AFHTTPSessionManager manager];
        
        /**
         *  AFHTTPRequestSerializer：是普通的 HTTP 的编码格式的，也就是 mid=10&method=userInfo&dateInt=20160818 这种格式的。
         *
         *  AFJSONRequestSerializer：是 JSON 编码格式的，也就是 {"mid":"11","method":"userInfo","dateInt":"20160818"} 这种格式的。
         *
         *  AFPropertyListRequestSerializer：是plist编码格式的。
         */
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
        _manager.requestSerializer.timeoutInterval = (weakSelf.timeoutInterval ? weakSelf.timeoutInterval : 10);
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",@"text/css", nil];
        
        //关闭缓存，避免干扰调试
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        //设置安全策略
        if(weakSelf.requestWay !=  requestWayHttpAndCAHttps) {[_manager setSecurityPolicy:[weakSelf securityPolicy]];}
    });
    
    //开启状态栏动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    return _manager;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    
    _timeoutInterval = timeoutInterval;
    [self sharedSessionManager].requestSerializer.timeoutInterval = (timeoutInterval > 0) ? timeoutInterval : 10;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)setRequestWay:(NetworkRequestWay)requestWay {
    
    _requestWay = requestWay;
    
    //设置安全策略
    [[self sharedSessionManager] setSecurityPolicy:(requestWay == requestWayHttpAndCAHttps) ? [AFSecurityPolicy defaultPolicy] : [self securityPolicy]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
