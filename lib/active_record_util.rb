module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def arrayify_attrs(*attrs)
      attrs.each do |attr|
        define_method :"#{attr}=" do |args|                    # def area_ids=(args)
          args = args.split(',') if String === args            #   args = args.split(',') if String === args
          super(args)                                          #   super(args)
        end                                                    # end
      end
    end

    def translate(*args)
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
end
ActiveRecord::Base.send(:include, ActiveRecordExtension)

class ActiveRecord::Base

  protected

  def uid_prefixed_by(prefix = 'NO')
    # FIXME, to avoid conflicts keys during convertion
    key_date_string = Time.now.strftime('%Y%m%d')
    date_string = Time.now.strftime('%y%m%d')

    day_uiq_num = "%04d" % $redis.incr("#{self.class.name}:#{key_date_string}")

    # avoid conflicts in identifier, as it is used to communicate with Alipay/Paypal
    unless Rails.env == 'production'
      prefix = prefix + Rails.env[0]
    end
    prefix + date_string + day_uiq_num
  end
end
