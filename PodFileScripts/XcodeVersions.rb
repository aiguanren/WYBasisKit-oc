# XcodeVersions.rb

# 检查 Xcode 版本是否等于指定版本(参数依次为：主版本、次版本以及补丁版本)
def xcode_version_equal_to(major, minor = 0, patch = 0)
  current_version = xcode_versions
  target_version = [major, minor, patch]
  compare_versions(current_version, target_version) == 0
end

# 检查 Xcode 版本是否小于等于指定版本(参数依次为：主版本、次版本以及补丁版本)
def xcode_version_less_than_or_equal_to(major, minor = 0, patch = 0)
  current_version = xcode_versions
  target_version = [major, minor, patch]
  compare_versions(current_version, target_version) <= 0
end

# 检查 Xcode 版本是否大于等于指定版本(参数依次为：主版本、次版本以及补丁版本)
def xcode_version_greater_than_or_equal_to(major, minor = 0, patch = 0)
  current_version = xcode_versions
  target_version = [major, minor, patch]
  compare_versions(current_version, target_version) >= 0
end

# 获取当前 Xcode 版本数组(返回值包含：主版本、次版本以及补丁版本)
def xcode_versions
  # 使用变量缓存避免重复获取
  return @cached_xcode_versions if @cached_xcode_versions
  
  output = `xcodebuild -version 2>&1`
  if output =~ /Xcode\s+(\d+(?:\.\d+){0,2})/
    versions = $1.split('.').map(&:to_i)
    puts "当前Xcode版本: #{versions.join('.')}"
    @cached_xcode_versions = versions
  else
    puts "⚠️ Podfile获取当前Xcode版本号失败 ⚠️"
    @cached_xcode_versions = [0, 0, 0] # 解析失败时返回安全值
  end
end

# 比较两个版本数组
def compare_versions(v1, v2)
  # 确保两个数组都有3个元素（不足的补0）
  v1 = (v1 + [0, 0, 0]).first(3)
  v2 = (v2 + [0, 0, 0]).first(3)
  
  # 依次比较主版本、次版本、补丁版本
  v1.each_with_index do |part, i|
    return -1 if part < v2[i]
    return 1 if part > v2[i]
  end
  0
end
