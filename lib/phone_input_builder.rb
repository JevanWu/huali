class PhoneInputBuilder
  attr_reader :phone, :phone_calling_code, :default_calling_code

  def initialize(phone, phone_calling_code, default_calling_code = "+86")
    @phone = phone
    @phone_calling_code = phone_calling_code
    @default_calling_code = default_calling_code
  end

  def selected_code
    return default_calling_code if phone.blank?

    if phone_valid?
      parsed_phone.international.split.first
    else
      phone_calling_code
    end
  end

  def text_field_value
    return if phone.blank?
    return phone.sub(phone_calling_code, '').sub(/^\s?/, '') unless phone_valid?

    if local_phone?
      parsed_phone.national
    else
      parsed_phone.international.sub(selected_code, '').sub(/^\s?/, '')
    end
  end

  private

  def parsed_phone
    Phonelib.parse(phone)
  end

  def local_phone?
    !phone.start_with?('+')
  end

  def phone_valid?
    parsed_phone.valid?
  end
end
