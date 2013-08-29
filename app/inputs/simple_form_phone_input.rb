class SimpleFormPhoneInput < SimpleForm::Inputs::Base
  def initialize(*)
    super
    @phone_input_helper = PhoneInputHelper.new(object, attribute_name)
  end

  def input
    "#{country_code_select}#{text_field}".html_safe
  end

  private

  def text_field
    html_options = { value: @phone_input_helper.text_field_value,
                     name: "#{object_name}[#{attribute_name}][]" }
    @builder.text_field(attribute_name, input_html_options.merge(html_options))
  end

  def country_code_select
    select_options = template.options_from_collection_for_select(CountryCode.all,
                                                                 :calling_code,
                                                                 :name,
                                                                 @phone_input_helper.selected_code)
    @builder.select(@phone_input_helper.calling_code_attribute_name,
                    select_options,
                    { prompt: false },
                    { class: 'input-small chosen-small', name: "#{object_name}[#{attribute_name}][]" })
  end
end
