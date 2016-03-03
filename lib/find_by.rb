class Module
  def create_finder_methods(*attributes)
    @@data_path = File.dirname(__FILE__) + "/../data/data.csv"
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    puts "creating finder methods"
    attributes.each do |attribute|
      puts "find_by_#{attribute}"
      find_by_method = %Q{
        def find_by_#{attribute}(value)
          object = CSV.read(@@data_path, headers:true, :header_converters => :symbol).find do |row|
            row.fetch(:#{attribute == "name" ? "product" : attribute}) == value
          end
          product_row_to_object(object)
        end
      }
      class_eval(find_by_method)
    end
  end
end
