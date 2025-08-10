# 定义podspec执行路径(远程验证时路径是从WYBasisKit-swift开始的，所以远程验证时需要填入podspec文件的路径：WYBasisKit/WYBasisKit/WYBasisKit/)
kit_path = "WYBasisKit/WYBasisKit/WYBasisKit/"

Pod::Spec.new do |kit|

   kit.name         = "WYBasisKit-oc"
   kit.version      = "2.0.0"
   kit.summary      = "WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的各种实用方法、扩展，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。"
   kit.description  = <<-DESC
                         Localizable: 国际化解决方案
                         Extension: 各种系统扩展
                         Networking: 网络请求解决方案
                         Activity: 活动指示器
                         Storage: 本地存储
                         Layout: 各种自定义控件
                         MediaPlayer: 直播、视频播放器
                         Codable: 数据解析
                         Authorization: 各种权限请求与判断
                   DESC

   kit.homepage     = "https://github.com/aiguanren/WYBasisKit-oc"
   kit.license      = { :type => "MIT", :file => "#{kit_path}License.md" }
   kit.author             = { "官人" => "aiguanren@icloud.com" }
   kit.ios.deployment_target = "13.0"
   kit.source       = { :git => "https://github.com/aiguanren/WYBasisKit-oc.git", :tag => "#{kit.version}" }
   #kit.source       = { :svn => "http://192.168.xxx.xxx:xxxx/xxx/xxx/WYBasiskit"}
   kit.source_files  = "#{kit_path}**/*.{swift,h,m}"
   kit.resources = ["#{kit_path}LoadingState/Loading.bundle"]
   kit.resource_bundles = {"WYBasisKit" => ["#{kit_path}PrivacyInfo.xcprivacy"]}
   kit.requires_arc = true
   # 手动指定模块名
   kit.module_name  = "WYBasisKitOC"
   kit.dependency "AFNetworking"
   kit.dependency "SDWebImage"
   kit.dependency "MJRefresh"
end
