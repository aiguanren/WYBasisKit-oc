#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LEGOImageCropperView.h"
#import "LEGOImageScrollView.h"
#import "LEGOImageTouchView.h"
#import "UIImage+LEGOFixOrientation.h"

FOUNDATION_EXPORT double LEGOImageCropperVersionNumber;
FOUNDATION_EXPORT const unsigned char LEGOImageCropperVersionString[];

