class CreateAsks < ActiveRecord::Migration[5.0]
  def change
    create_table :asks do |t|
      t.string :exchange
      t.float :value
      t.references :opportunity, foreign_key: true

      t.timestamps
    end
  end
end
