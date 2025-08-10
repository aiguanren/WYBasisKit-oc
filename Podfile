platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!
#use_frameworks! :linkage => :static：
use_modular_headers!
install! 'cocoapods', warn_for_unused_master_specs_repo: false

# 使用Cocoapods清华源
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

# 使用Cocoapods官方源
#source 'https://github.com/CocoaPods/Specs.git'

# 加载脚本管理器
require_relative 'Scripts/PodFileConfig/Podfile'

# 执行本地验证或者pod命令的时候需要把podspec里面kit_path设置为 ""(空) 才能正确加载代码、资源等文件路径
modify_kit_path_in_podspec("./WYBasisKit/WYBasisKit/WYBasisKit/WYBasisKit-swift.podspec", "", false)

# 选择设置选项（三选一）
# configure_settings_option(SETTING_OPTIONS[:pods_only])    # 只设置Pods项目
# configure_settings_option(SETTING_OPTIONS[:user_only])    # 只设置用户项目
configure_settings_option(SETTING_OPTIONS[:all_projects])   # 设置所有项目(默认)

# 设置Pods项目版本(仅限从Podfile解析部署版本失败时有效)
#set_pods_deployment_target('13.0')

workspace 'WYBasisKit.xcworkspace' # 多个项目时需要指定target对应的xcworkspace文件

target 'WYBasisKit' do
  project 'WYBasisKit/WYBasisKit.xcodeproj' # 多个项目时需要指定target对应的xcodeproj文件
  pod 'AFNetworking'
  pod 'MJRefresh'
  pod 'Masonry'

  # 图片裁剪库
  pod 'PureCamera'
  pod 'LEGOImageCropper'
  
  # 直播/视频播放器(基于IJK编写优化)
  pod "FSPlayer", :podspec => 'https://github.com/debugly/fsplayer/releases/download/1.0.2/FSPlayer.spec.json'
  
  # 根据Xcode版本号指定三方库的版本号
  if xcode_version_less_than_or_equal_to(14, 2)
    pod 'SDWebImage', '5.20.1'
  else
    pod 'SDWebImage'
  end
end

project 'path/to/Project.xcodeproj'
target 'WYBasisKitVerify' do
  project 'WYBasisKitVerify/WYBasisKitVerify.xcodeproj' # 多个项目时需要指定target对应的xcodeproj文件
  pod 'WYBasisKit-oc', :path => 'WYBasisKit/WYBasisKit/WYBasisKit'
  pod 'Masonry'
  # 根据Xcode版本号指定三方库的版本号
  if xcode_version_less_than_or_equal_to(14, 2)
    pod 'SDWebImage', '5.20.1'
  else
    pod 'SDWebImage'
  end
end

# 准备执行pod命令(执行pod命令前的处理)
pre_install do |installer|
  
end

# 结束执行pod命令(执行pod命令后的处理)
post_install do |installer|
  apply_selected_settings(installer)
  restore_kit_path_in_podspec(false)
end
