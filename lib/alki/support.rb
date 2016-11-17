require 'alki/support/version'

module Alki
  module Support
    def self.classify(str)
      str.split('/').map do |c|
        c.split('_').map{|n| n.capitalize }.join('')
      end.join('::')
    end

    def self.constantize(name)
      name.split('::').inject(Object) do |obj,el|
        return nil unless obj.const_defined? el
        obj.const_get el
      end
    end

    def self.caller_path(root,caller_depth: 1)
      path = caller_locations(caller_depth,1)[0].absolute_path
      root = File.join(root,'')
      if path.start_with?(root) && path.end_with?('.rb')
        path[root.size..-4]
      end
    end

    def self.find_pkg_root(path)
      find_root(path) {|dir| is_pkg_root? dir }
    end

    def self.find_root(path)
      old_dir = File.absolute_path(path)
      dir = File.dirname(old_dir)
      until dir == old_dir || yield(dir)
        old_dir = dir
        dir = File.dirname(old_dir)
      end
      if dir != old_dir
        dir
      end
    end

    def self.is_pkg_root?(dir)
      File.exists?(File.join(dir,'config','package.rb')) or
        File.exists?(File.join(dir,'Gemfile')) or
        !Dir.glob(File.join(dir,'*.gemspec')).empty?
    end
  end
end