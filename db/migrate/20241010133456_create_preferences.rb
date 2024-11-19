class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences do |t|
      t.string :name, null: false
      t.text :description, null:false
      t.boolean :restriction, null:false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
