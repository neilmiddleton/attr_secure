require 'active_record'
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :fake_database, :force => true do |t|
    t.string   :title
    t.timestamps
  end
end
