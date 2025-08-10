# PodSpec.rb

module PodSpecModifier
    @modifys = {}
    
    # 修改podspec文件中的kit_path值（在pre_install钩子中调用）
    def self.modify_kit_path_in_podspec(podspec_path, new_kit_path, showLog = false)
        @show_log = showLog  # 使用类实例变量
        
        # 确保已初始化
        @modifys ||= {}
        
        # 只注册尚未注册或值不同的修改
        existing = @modifys[podspec_path]
        if existing && existing[:new_value] == new_kit_path
            puts "ℹ️ 已注册相同修改: #{podspec_path} => #{new_kit_path}" if @show_log
            return
        end
        
        # 注册修改，注意只在第一次保存备份内容，避免覆盖
        @modifys[podspec_path] ||= {
            original_value: nil,
            modified: false,
            backup_content: nil
        }
        @modifys[podspec_path][:new_value] = new_kit_path
        
        puts "✅ 已注册: #{podspec_path} => #{new_kit_path}" if @show_log
        
        # 自动应用修改
        apply_all_modifys_for(podspec_path)
    end
    
    # 还原所有修改（在post_install钩子中调用）
    def self.restore_kit_path_in_podspec(showLog = false)
        @show_log = showLog  # 使用类实例变量
        return if @modifys.nil? || @modifys.empty?
        
        failed_restores = []
        
        @modifys.each do |podspec_path, data|
            next unless data[:modified] && data[:original_value]
            
            result = restore(podspec_path, data[:backup_content], data[:original_value])
            if result[:success]
                puts "\n✅ 已还原 #{podspec_path}: #{result[:message]}" if @show_log
            else
                failed_restores << podspec_path
                puts "\n❌ #{podspec_path} 还原失败: #{result[:message]}" if @show_log
            end
        end
        
        # 清空修改记录
        @modifys.clear
        
        # 报告失败情况
        if failed_restores.any? && @show_log
            puts "\n⚠️ 以下文件还原失败，请手动检查:"
            failed_restores.each { |path| puts "  - #{path}" }
        end
    end
    
    private
    
    # 为单个文件应用修改（内部方法）
    def self.apply_all_modifys_for(podspec_path)
        data = @modifys[podspec_path]
        return unless data && !data[:modified]
        
        # 读取并备份文件内容（只在第一次修改时备份）
        begin
            data[:backup_content] = File.read(podspec_path) if data[:backup_content].nil?
        rescue => e
            puts "\n❌ 无法读取 #{podspec_path}: #{e.message}" if @show_log
            return
        end
        
        result = modify(podspec_path, data[:new_value])
        if result[:success]
            data[:original_value] = result[:original_value]
            data[:modified] = true
            puts "\n✅ 临时修改 #{podspec_path}: #{result[:message]}" if @show_log
        else
            # 恢复备份内容
            File.write(podspec_path, data[:backup_content]) if data[:backup_content]
            puts "\n❌ #{podspec_path} 修改失败: #{result[:message]}" if @show_log
        end
    end
    
    # 正则表达式常量
    KIT_PATH_REGEX = /
      ^\s*             # 行首空格
      kit_path\s*=\s*  # 属性名和等号
      (['"])           # 捕获引号类型（单或双）
      ([^'"]*)         # 捕获路径值
      \1               # 匹配相同的引号
    /x
    
    # 实际修改逻辑
    def self.modify(podspec_path, new_kit_path)
        # 验证参数（允许 new_kit_path 为空字符串）
        if podspec_path.to_s.empty?
            return error_response("\n必须提供 podspec 文件路径")
        end
        
        if new_kit_path.nil?
            return error_response("\n必须提供新的 kit_path 值（空值请使用空字符串 ''）")
        end
        
        unless File.exist?(podspec_path)
            return error_response("\n#{podspec_path} 路径下没有找到podspec文件")
        end
        
        # 读取文件内容
        content = File.read(podspec_path)
        
        # 使用优化的正则提取当前的kit_path值
        match_data = content.match(KIT_PATH_REGEX)
        unless match_data
            return error_response("\npodspec中没有找到 kit_path 属性")
        end
        
        # 获取当前值
        quote_type = match_data[1]
        current_kit_path = match_data[2]
        
        # 检查新值是否与当前值相同
        if current_kit_path == new_kit_path
            return success_response(
                current_kit_path,
                "\npodspec中kit_path的值与传入的值相同，跳过修改"
            )
        end
        
        # 替换内容（保留原始格式）
        new_content = content.sub(KIT_PATH_REGEX) do |match|
            # 保留原始格式，只替换路径值
            "kit_path = #{quote_type}#{new_kit_path}#{quote_type}"
        end
        
        # 写回文件
        File.write(podspec_path, new_content)
        
        success_response(
            current_kit_path,
            "\n已修改kit_path '#{current_kit_path}' 为 '#{new_kit_path}'",
            new_kit_path
        )
    rescue => e
        error_response("\n修改podspec失败: #{e.message}\n#{e.backtrace.join("\n")}")
    end
    
    # 恢复podspec文件中的kit_path值，优先写回备份内容
    def self.restore(podspec_path, backup_content, original_value)
        if backup_content
            begin
                File.write(podspec_path, backup_content)
                return success_response(original_value, "\n已从备份还原文件内容")
            rescue => e
                return error_response("\n写回备份内容失败: #{e.message}")
            end
        else
            # 如果没有备份，只能尝试用 modify 恢复 kit_path
            modify(podspec_path, original_value)
        end
    end
    
    # 私有方法：错误响应
    def self.error_response(message)
        {success: false, message: message}
    end
    
    # 私有方法：成功响应
    def self.success_response(original, message, new_val = nil)
        {
            success: true,
            message: message,
            original_value: original,
            new_value: new_val
        }
    end
end
