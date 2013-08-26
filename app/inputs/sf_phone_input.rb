class SfPhoneInput < SimpleForm::Inputs::Base
  def input
    "#{country_code_select}#{text_field}".html_safe
  end

  private

  def phone_calling_code
    object.send(calling_code_attribute_name)
  end

  def calling_code_attribute_name
    :"#{attribute_name}_calling_code"
  end

  def phone
    object.send(attribute_name)
  end

  def phone_input_helper
    PhoneInputHelper.new(phone, phone_calling_code, CountryCode.default.calling_code)
  end

  delegate :selected_code, :text_field_value, to: :phone_input_helper

  def text_field
    html_options = { value: text_field_value, name: "#{object_name}[#{attribute_name}][]" }
    @builder.text_field(attribute_name, input_html_options.merge(html_options))
  end

  def country_code_select
    @builder.select(calling_code_attribute_name,
                    template.options_from_collection_for_select(CountryCode.all, :calling_code, :name, selected_code),
                    { prompt: false },
                    { class: 'input-small chosen-small', name: "#{object_name}[#{attribute_name}][]" })
  end
end
