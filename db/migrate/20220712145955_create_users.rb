class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.string :age
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end

    add_index :users, [:company_id, :email], :unique => true, :name => 'by_company_email'
  end
end
