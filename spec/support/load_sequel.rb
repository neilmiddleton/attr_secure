require 'sequel'

DB = Sequel.sqlite

DB.create_table :fake_database do
  primary_key :id
  column :title, :string
end
