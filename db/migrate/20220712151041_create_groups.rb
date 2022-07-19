class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name, limit: 100
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    add_index :groups, [:company_id, :name], :unique => true, :name => 'by_company_name'
  end
end
