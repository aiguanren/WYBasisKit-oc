# XcodeSettings.rb

# 可配置的默认部署目标
$pods_deployment_target = '13.0'

# 设置Pods项目版本(仅限从Podfile解析部署版本失败时有效)
def set_pods_deployment_target(version)
  $pods_deployment_target = version
end

# 设置用户项目和Pods项目(排除一些警告，修复一些编译问题)
def apply_all_project_settings(installer)
  apply_pod_project_settings(installer)
  apply_user_project_settings(installer)
end

# 设置Pods项目
def apply_pod_project_settings(installer)
    
  # 获取 Podfile 中设置的部署版本
  deployment_target = podfile_deployment_target(installer)
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 设置最低部署版本(Podfile中设置的部署版本)
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
      
      # 设置排除架构(模拟器构建时排除 arm64 架构，防止M系列芯片模拟器编译失败）
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      
      # 修复DT_TOOLCHAIN_DIR警告
      fix_dt_toolchain_warning(config)
    end
  end
end

# 设置用户项目
def apply_user_project_settings(installer)
    
  user_projects = installer.aggregate_targets.map(&:user_project).compact.uniq
  
  # 备用检测机制：从workspace中查找项目
  if user_projects.empty? && File.exist?(installer.workspace_path.to_s)
    workspace = Xcodeproj::Workspace.new_from_xcworkspace(installer.workspace_path.to_s)
    user_projects = workspace.file_references
      .map { |ref| File.join(File.dirname(installer.workspace_path.to_s), ref.path) }
      .select { |path| path.end_with?('.xcodeproj') }
      .map { |path| Xcodeproj::Project.open(path) rescue nil }
      .compact
  end

  # 应用设置到所有检测到的用户项目
  user_projects.each do |project|
    modified = false
    
    project.build_configurations.each do |config|
      # 只有当设置不存在或不是我们需要的值时才更新
      if config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] != "arm64"
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        modified = true
      end
    end
    
    project.save if modified
  end
end

private

# 修复DT_TOOLCHAIN_DIR相关警告
def fix_dt_toolchain_warning(config)
  return unless config.base_configuration_reference &&
                config.base_configuration_reference.real_path &&
                File.exist?(config.base_configuration_reference.real_path)
  
  xcconfig_path = config.base_configuration_reference.real_path
  xcconfig = File.read(xcconfig_path)
  xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
  
  if xcconfig_mod != xcconfig
    File.write(xcconfig_path, xcconfig_mod)
  end
end

# 从 Podfile 中解析部署版本
def podfile_deployment_target(installer)
  version = nil

  # 1. 首先尝试从Podfile platform :ios这里直接获取
  if installer.podfile.target_definition_list.any?
    platform = installer.podfile.target_definition_list.first.platform
    version = platform.to_s if platform
  end
  
  # 2. 如果直接获取失败，尝试解析 Podfile 文件内容
  unless version
    podfile_path = installer.podfile.defined_in_file
    if podfile_path && File.exist?(podfile_path)
      podfile_content = File.read(podfile_path)
      if match = podfile_content.match(/platform\s*:ios\s*,\s*['"]([\d.]+)['"]/)
        version = match[1]
      end
    end
  end
  
  # 3. 如果所有方法都失败，使用配置的默认值
  version ||= $default_deployment_target
  
  # 移除非数字和点号以外的字符
  cleaned = version.to_s.gsub(/[^\d.]/, '')
  
  # 确保版本号至少有一个点号分隔符
  unless cleaned.include?('.')
    cleaned += '.0'
  end
  
  # 确保版本号格式为 X.X 或 X.X.X
  parts = cleaned.split('.')
  if parts.size < 2
    cleaned = "#{parts[0]}.0"
  end
  
  # 返回处理后的版本
  cleaned
end
