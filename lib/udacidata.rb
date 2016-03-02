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
end
