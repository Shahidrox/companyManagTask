class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :code, limit: 50, null: false, index: { unique: true }
      t.string :name, limit: 200

      t.timestamps
    end
  end
end
