# Podfile.rb

# 加载所有依赖脚本
require_relative 'PodSpec'
require_relative 'XcodeVersions'
require_relative 'XcodeSettings'

# 提供设置选项常量
SETTING_OPTIONS = {
    pods_only: 1, # 只设置Pods项目
    user_only: 2, # 只设置用户项目
    all_projects: 3 # 同时设置Pods项目和用户项目
}

# 修改(临时)podspec文件中要修改的kit_path的值
def modify_kit_path_in_podspec(podspec_path, kit_path, showLog)
    PodSpecModifier.modify_kit_path_in_podspec(podspec_path, kit_path, showLog)
end

# 还原podspec文件中要修改的kit_path的值
def restore_kit_path_in_podspec(showLog)
    PodSpecModifier.restore_kit_path_in_podspec(showLog)
end

# 配置设置选项（默认为所有项目）
def configure_settings_option(option = SETTING_OPTIONS[:all_projects])
    @settings_option = option
end

# 设置Pods项目版本(仅限从Podfile解析部署版本失败时有效)
def configure_pods_deployment_target(version)
    $pods_deployment_target = version
end

# 应用选中的设置
def apply_selected_settings(installer)
    case @settings_option || SETTING_OPTIONS[:all_projects]
        when SETTING_OPTIONS[:pods_only]
        apply_pod_project_settings(installer)
        when SETTING_OPTIONS[:user_only]
        apply_user_project_settings(installer)
        when SETTING_OPTIONS[:all_projects]
        apply_all_project_settings(installer)
        else
        puts "⚠️ 未知的设置选项，默认应用到所有项目 ⚠️"
        apply_all_project_settings(installer)
    end
end
