class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.string :exchange
      t.float :value
      t.references :opportunity, foreign_key: true

      t.timestamps
    end
  end
end
