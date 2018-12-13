class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.integer :score
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
