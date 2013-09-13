class FormtasticPhoneInput
  include Formtastic::Inputs::Base

  def initialize(*)
    super
    @phone_input_helper = PhoneInputHelper.new(object, method)
  end

  def to_html
    input_wrapping do
      label_html <<
      "<div style='display: inline-block'>#{country_code_select}#{text_field}</div>".html_safe
    end
  end

  private

  def text_field
    html_options = { value: @phone_input_helper.text_field_value,
                     name: "#{object_name}[#{method}][]" }
    builder.text_field(method, input_html_options.merge(html_options))
  end

  def country_code_select
    select_options = template.options_from_collection_for_select(CountryCode.all,
                                                                 :calling_code,
                                                                 :name,
                                                                 @phone_input_helper.selected_code)
    builder.select(@phone_input_helper.calling_code_attribute_name,
                    select_options,
                    { prompt: false },
                    { class: 'input-small chosen-small', name: "#{object_name}[#{method}][]" })

  end
end
