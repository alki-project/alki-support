require 'alki/support/version'

module Alki
  def self.load(name_or_obj)
    Support.load name_or_obj
  end
  module Support
    def self.load(name_or_obj)
      if name_or_obj.is_a?(String)
        name = name_or_obj
        require name
        obj = constantize classify name
      else
        obj = name_or_obj
      end
      obj
    end

    def self.create_constant(name, value, parent=nil)
      parent ||= Object
      *ans, ln = name.to_s.split('::')
      ans.each do |a|
        unless parent.const_defined? a
          parent.const_set a, Module.new
        end
        parent = parent.const_get a
      end

      parent.const_set ln, value
    end

    def self.classify(str)
      str.split('/').map do |c|
        c.split('_').map{|n| n.capitalize }.join('')
      end.join('::')
    end

    def self.constantize(name,parent = nil)
      name.split('::').inject(parent || Object) do |obj,el|
        return nil unless obj.const_defined? el, false
        obj.const_get el, false
      end
    end

    def self.path_name(path,root=File.dirname(path))
      root = File.join(root,'')
      if path.start_with?(root) && path.end_with?('.rb')
        path[root.size..-4]
      end
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
  end
end
