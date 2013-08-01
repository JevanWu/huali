module MailerHelper
  def find_product_count_from_collection(collection, name_zh = nil, date = nil)
    case get_collection_type(collection)
    when :products_with_count
      calculate_count(collection, name_zh)
    when :products_with_count_by_date
      calculate_count_by_date(collection, name_zh, date)
    end
  end

  private

  def product_count_by_name(products_with_count, name_zh)
    products_with_count.find do |product_with_count|
      product_with_count.name_zh == name_zh
    end.try(:product_count).to_i
  end

  def sum_product_count(products_with_count)
    products_with_count.inject(0) do |sum, product_with_count|
      sum + product_with_count.product_count.to_i
    end
  end

  def calculate_count(collection, name_zh)
    if name_zh
      product_count_by_name(collection, name_zh)
    else
      sum_product_count(collection)
    end
  end

  def calculate_count_by_date(collection, name_zh, date)
    return nil if name_zh.nil? && date.nil?

    if date
      products_with_count = collection.find { |p| p[:date] == date }[:result]

      if name_zh
        return product_count_by_name(products_with_count, name_zh)
      else
        return sum_product_count(products_with_count)
      end
    end
  end

  def get_collection_type(collection)
    if collection.any? { |c| c.is_a?(Hash) }
      :products_with_count_by_date
    else
      :products_with_count
    end
  end
end
