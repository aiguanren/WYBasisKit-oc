//
//  WYFileModel.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/8/28.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "WYFileModel.h"

@implementation WYFileModel

- (instancetype)init {
    
    if(self == [super init]) {
        
        self.fileType = fileTypeImage;
    }
    return self;
}

- (void)setMimeType:(NSString *)mimeType {
    
    _mimeType = mimeType;
    if([self emptyStr:mimeType].length == 0) {
        
        switch (_fileType) {
            case fileTypeImage:
                _mimeType = @"image/jpeg";
                break;
                
            case fileTypeAudio:
                _mimeType = @"audio/aac";
                break;
                
            case fileTypeVideo:
                _mimeType = @"video/mp4";
                break;
                
            case fileTypeUrl:
                _mimeType = @"application/octet-stream";
                break;
                
            default:
                break;
        }
    }
}

- (void)setFileName:(NSString *)fileName {
    
    _fileName = [self emptyStr:fileName];
}

- (void)setFolderName:(NSString *)folderName {
    
    _folderName = [self emptyStr:folderName];
}

- (void)setFileType:(FileType)fileType {
    
    _fileType = fileType;
    self.mimeType = @"";
}

- (void)setCompressionQuality:(CGFloat)compressionQuality {
    
    _compressionQuality = compressionQuality;
    if((compressionQuality <= 0.0f) || (compressionQuality > 1.0f)) {
        
        _compressionQuality = 1.0f;
    }
}

- (void)setFileUrl:(NSString *)fileUrl {
    
    _fileUrl = [self emptyStr:fileUrl];
}

- (void)setFileImage:(UIImage *)fileImage {
    
    _fileImage = fileImage;
    if(self.fileData == nil) {
        
        self.fileData = UIImageJPEGRepresentation(fileImage, self.compressionQuality);
        _fileImage = nil;
    }
}

- (void)setFileData:(NSData *)fileData {
    
    _fileData = fileData;
    if((fileData != nil) && (self.fileType == fileTypeImage)) {
        
        _fileData = UIImageJPEGRepresentation([UIImage imageWithData:fileData], self.compressionQuality);
    }
}

- (NSString *)emptyStr:(NSString *)str {
    
    if(([str isKindOfClass:[NSNull class]]) || ([str isEqual:[NSNull null]]) || (str == nil) || (!str)) {
        
        str = @"";
    }
    return str;
}

@end
