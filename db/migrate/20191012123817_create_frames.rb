class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames do |t|
      t.references :game, foreign_key: true, index: true
      t.integer :frame_index
      t.integer :score, default: 0
      t.integer :ball_one
      t.integer :ball_two
      t.integer :ball_three
      t.integer :frame_type, default: 1
      t.boolean :closed, default: false
      t.timestamps
    end
  end
end
