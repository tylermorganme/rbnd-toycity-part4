require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(attributes = nil)

    object = self.new(attributes)

    CSV.open(@@data_path, "ab") do |csv|
      csv << ([object.id] + attributes.values)
    end
    # If the object's data is already in the database
    # create the object
    # return the object

    # If the object's data is not in the database
    # create the object
    # save the data in the database
    # return the object
    object
  end

  def self.all
    result = []
    CSV.foreach(@@data_path, headers:true, :header_converters => :symbol) do |row|
       result << product_row_to_object(row)
    end
    result
  end

  def self.first(n=1)
    if n == 1
      return product_row_to_object(CSV.read(@@data_path, headers:true, :header_converters => :symbol).first)
    else
      result = []
      CSV.read(@@data_path, headers:true, :header_converters => :symbol).first(n).each do |row|
        result << product_row_to_object(row)
      end
      return result
    end
  end

  def self.last(n=1)
    if n == 1
      return product_row_to_object(CSV.read(@@data_path, headers:true, :header_converters => :symbol)[-1])
    else
      result = []
      CSV.read(@@data_path, headers:true, :header_converters => :symbol).values_at(*(-n..-1).to_a).each do |row|
        result << product_row_to_object(row)
      end
      return result
    end
  end

  def self.find(id)
    object = CSV.read(@@data_path, headers:true, :header_converters => :symbol).find do |row|
      row.fetch(:id).to_i === id
    end
    product_row_to_object(object)
  end

  def self.destroy(id)
    n = 0
    object = self.find(id)
    data = CSV.table(@@data_path)
    data.delete_if do |row|
      row[:id] == id
    end
    File.open(@@data_path, 'w') do |f|
      f.write(data.to_csv)
    end
    object
  end

  def self.where(options={})
    rows = CSV.read(@@data_path, headers:true, :header_converters => :symbol).find_all do |row|
      if options.keys[0] == :name
        row.fetch(:product) == options.values[0]
      else
        row.fetch(:brand) == options.values[0]
      end
    end
    results = []
    rows.each do |row|
      results << product_row_to_object(row)
    end
    results
  end

  def update(options={})
    Product.destroy(self.id)
    hash = {}
    x = self.send("id")
    keys = self.instance_variables.map {|key| key[1..-1].to_sym}
    keys.each do |key, value|
      key == :name if key == :product
      if options.has_key? key
        hash[key] = options[key]
      else
        hash[key] = self.send(key.to_s)
      end
    end
    Product.create(hash)
  end

  def self.method_missing(method_name, *arguments)
    attribute = method_name.to_s[8..-1]
    if method_name.to_s.start_with? "find_by" # TODO: Need to add more checks
      Module::create_finder_methods(method_name.to_s[8..-1])
      self.send(method_name, *arguments)
    else
      super
    end
  end

  def self.product_row_to_object(row)
    hash = row.to_hash
    hash[:name] = hash.delete(:product)
    self.new(hash)
  end

end
