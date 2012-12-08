class ::ActiveRecord::Base
  def self.translate(*args)
    args.each do |attr_name|
      define_method(attr_name) do |*args|
        case I18n.locale
        when :"zh-CN"
          self.send("#{attr_name}_zh")
        when :en
          self.send("#{attr_name}_en")
        end
      end
    end
  end
end
