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
       result << self.new(row.to_hash)
    end
    result
  end

  def self.first(n=1)
    if n == 1
      return self.new(CSV.read(@@data_path, headers:true, :header_converters => :symbol).first.to_hash)
    else
      result = []
      CSV.read(@@data_path, headers:true, :header_converters => :symbol).first(n).each do |row|
        result << self.new(row.to_hash)
      end
      return result
    end
  end

  def self.last(n=1)
    if n == 1
      return self.new(CSV.read(@@data_path, headers:true, :header_converters => :symbol)[-1].to_hash)
    else
      result = []
      CSV.read(@@data_path, headers:true, :header_converters => :symbol).values_at(*(-n..-1).to_a).each do |row|
        result << self.new(row.to_hash)
      end
      return result
    end
  end

  def self.find(index)
    object = CSV.read(@@data_path, headers:true, :header_converters => :symbol).find do |row|
      row.fetch(:id).to_i === index
    end
    self.new(object.to_hash)
  end

  def self.destroy(index)
    n = 0
    object = self.find(index)
    data = CSV.table(@@data_path)
    data.delete_if do |row|
      row[:id] == index
    end
    File.open(@@data_path, 'w') do |f|
      f.write(data.to_csv)
    end
    object
  end
end
