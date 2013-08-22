class PhoneInput < SimpleForm::Inputs::Base
  def input
    "<div>#{country_code_select}#{text_field}</div>".html_safe
  end

  private

  def selected_code
    if phone.blank?
      CountryCode.find_by_code(Phonelib.default_country).calling_code
    else
      parsed_phone.international.split.first
    end
  end

  def phone
    phone = object.send(attribute_name)
  end

  def parsed_phone
    Phonelib.parse(phone)
  end

  def local_phone?
    parsed_phone.country == Phonelib.default_country
  end

  def text_field_value
    return phone if phone.blank?

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
    select_options = template.options_from_collection_for_select(CountryCode.all, :calling_code, :name, selected_code)

    select_name = "#{object_name}[#{attribute_name}_calling_code]"
    country_code_select = template.select_tag(select_name,
                                              select_options,
                                              class: 'input-small chosen-small')
  end
end
