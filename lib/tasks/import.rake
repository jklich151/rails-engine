require 'csv'

task :import => [:environment] do
  system'rake db:reset'
  puts 'now importing customers'
  desc 'Import customers from csv file'
    file = 'db/data/customers.csv'
      CSV.foreach(file, headers: true) do |row|
        customer_hash = row.to_hash
        customer = Customer.where(id: customer_hash["id"])
        if customer.count == 1
          customer.first.update_attributes(customer_hash)
        else
          Customer.create!(customer_hash)
        end
      end

  puts 'now importing merchants'
  desc 'Import merchant from csv file'
   file = 'db/data/merchants.csv'
    CSV.foreach(file, headers: true) do |row|
      merchant_hash = row.to_hash
      merchant = Merchant.where(id: merchant_hash["id"])
      if merchant.count == 1
        merchant.first.update_attributes(merchant_hash)
      else
        Merchant.create!(merchant_hash)
      end
  end

ActiveRecord::Base.connection.execute("ALTER SEQUENCE merchants_id_seq RESTART WITH 101")

  puts 'now importing items'
  desc 'Import item from csv file'
    file = 'db/data/items.csv'
      CSV.foreach(file, headers: true) do |row|
        item_hash = row.to_hash
        item = Item.where(id: item_hash["id"])
        item_hash["unit_price"] = ((item_hash["unit_price"].to_i) /100)
        if item.count == 1
          item.first.update_attributes(item_hash)
        else
          Item.create!(item_hash)
        end
      end

  ActiveRecord::Base.connection.execute("ALTER SEQUENCE items_id_seq RESTART WITH 2484")

puts 'now importing invoices'
desc 'Import invoice from csv file'
    file = 'db/data/invoices.csv'
      CSV.foreach(file, headers: true) do |row|
        invoice_hash = row.to_hash
        invoice = Invoice.where(id: invoice_hash["id"])
          if invoice.count == 1
            invoice.first.update_attributes(invoice_hash)
          else
            Invoice.create!(invoice_hash)
          end
        end

  puts 'now importing invoice items'
  desc 'Import invoice_item from csv file'
     file = 'db/data/invoice_items.csv'
      CSV.foreach(file, headers: true) do |row|
        invoice_item_hash = row.to_hash
        invoice_item_hash["unit_price"] = ((invoice_item_hash["unit_price"].to_i) /100)
        if invoice_item_hash.count == 1
          invoice_item_hash.first.update_attributes(invoice_item_hash)
        else
          InvoiceItem.create!(invoice_item_hash)
        end
      end

  puts 'now importing transactions'
  desc 'Import transaction from csv file'
      file = 'db/data/transactions.csv'
        CSV.foreach(file, headers: true) do |row|
          transaction_hash = row.to_hash
          transaction = Transaction.where(id: transaction_hash["id"])
          if transaction.count == 1
            transaction.first.update_attributes(transaction_hash)
          else
            Transaction.create!(transaction_hash)
          end
        end
end
