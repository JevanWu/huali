class SfPhoneInput < SimpleForm::Inputs::Base
  def input
    "#{country_code_select}#{text_field}".html_safe
  end

  private

  def selected_code
    return CountryCode.default.calling_code if phone.blank?

    if phone_valid?
      parsed_phone.international.split.first
    else
      phone_calling_code
    end
  end

  def phone_calling_code
    object.send(calling_code_attribute_name)
  end

  def calling_code_attribute_name
    :"#{attribute_name}_calling_code"
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

  def local_phone?
    !phone.start_with?('+')
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

  def text_field
    @builder.text_field(attribute_name,
                        input_html_options.merge(value: text_field_value))
  end

  def country_code_select
    @builder.select(calling_code_attribute_name,
                    template.options_from_collection_for_select(CountryCode.all, :calling_code, :name, selected_code),
                    { prompt: false },
                    { class: 'input-small chosen-small' })
  end
end
