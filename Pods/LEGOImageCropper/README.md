# LEGOImageCropper

[![CI Status](https://img.shields.io/travis/564008993@qq.com/LEGOImageCropper.svg?style=flat)](https://travis-ci.org/564008993@qq.com/LEGOImageCropper)
[![Version](https://img.shields.io/cocoapods/v/LEGOImageCropper.svg?style=flat)](https://cocoapods.org/pods/LEGOImageCropper)
[![License](https://img.shields.io/cocoapods/l/LEGOImageCropper.svg?style=flat)](https://cocoapods.org/pods/LEGOImageCropper)
[![Platform](https://img.shields.io/cocoapods/p/LEGOImageCropper.svg?style=flat)](https://cocoapods.org/pods/LEGOImageCropper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LEGOImageCropper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LEGOImageCropper'
```

**LEGOImageCropper** is the picture cropper, support to resizeWHScale, set size, rotate angle, fine adjust angle, crop product image. 图片裁剪，支持大小缩放，设置大小，旋转角度，微调角度，裁剪产品图片。

**⚠️⚠️⚠️ WARNING ⚠️⚠️⚠️** **LEGOImageCropper** is still in **BETA**. Everything in this library is tested and working, and is used in the official project app, but there may still be unexpected results. Please, be careful. 这个库中的所有内容都经过了测试和工作，并在正式的项目应用程序中使用，但可能仍然会有意外的结果。拜托，小心点。

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

- [x] Resize WH Scale.  缩放尺寸
- [x] Allow two fingers rotate angle freely.  双指调整缩放旋转
- [x] rotate angle by control.  角度外部控制
- [x] Angle fine tuning.  角度微调  
- [x] Double click to reset picture.  双击重置

## Demonstration
![image](https://github.com/legokit/LEGOImageCropper/blob/master/Resources/LEGOImageCropperGif.gif)

## Requirements

- iOS 8.0+
- Xcode 10.0+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate LEGOImageCropper into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'LEGOImageCropper'
```

### Manually

If you prefer not to use any of the dependency mentioned above, you can integrate LEGOImageCropper into your project manually. Just drag & drop the `Sources` folder to your project.

## Usage

```
/** crop picture 裁剪方法实例 */

    [self.imageCropperView cropImageWithComplete:^(UIImage *resizeImage) {
        NSLog(@"resizeImage=%@",resizeImage);
    }];
    
```


For details, see example for LEGOImageCropper.

## Author

564008993@qq.com, yangqingren@yy.com

## License

LEGOImageCropper is available under the MIT license. See the LICENSE file for more info.




