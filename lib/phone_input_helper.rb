class PhoneInputHelper
  attr_reader :object, :attribute_name, :default_calling_code

  def initialize(object, attribute_name, default_calling_code = "+86")
    @object = object
    @attribute_name = attribute_name
    @default_calling_code = default_calling_code
  end

  def selected_code
    return default_calling_code if phone.blank?

    if phone_valid?
      parsed_phone.international.split.first
    else
      phone_calling_code || default_calling_code
    end
  end

  def text_field_value
    return if phone.blank?

    if phone_valid? && local_phone?
      parsed_phone.national
    else
      phone.sub(selected_code, '').sub(/^\s?/, '')
    end
  end

  def calling_code_attribute_name
    :"#{attribute_name}_calling_code"
  end

  private

  def local_phone?
    selected_code == "+86"
  end

  def phone_calling_code
    object.send(calling_code_attribute_name)
  end

  def phone
    object.send(attribute_name)
  end

  def parsed_phone
    Phonelib.parse(phone)
  end

  def phone_valid?
    parsed_phone.valid?
  end
end
