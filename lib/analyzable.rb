module Analyzable
  # Your code goes here!
  def average_price(data)
    (data.inject(0) {|total, item| total += item.price.to_f} / data.length).round(2)
  end

  def count_by_brand(data)
    result = {}
    data.each do |item|
      if result.has_key? item.brand
        result[item.brand] += 1
      else
        result[item.brand] = 1
      end
    end
    result
  end

  def count_by_name(data)
    result = {}
    data.each do |item|
      if result.has_key? item.name
        result[item.name] += 1
      else
        result[item.name] = 1
      end
    end
    result
  end

  def print_report(data)
    report_items = []
    report_items << "Inventory by Brand:"
    count_by_brand(data).each do |key, value|
      report_items << "  - #{key}: #{value}"
    end
    report_items << "Inventory by Name:"
    count_by_name(data).each do |key, value|
      report_items << "  - #{key}: #{value}"
    end
    report_items.join("\n")
  end
end
