require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes
def db_seed
  new_products = []
  10.times do
    # you will write the "create" method as part of your project
    new_products << Product.create(brand: Faker::Company.name,
                                 name: Faker::Commerce.product_name,
                                 price: Faker::Commerce.price)
  end
  new_products
end
