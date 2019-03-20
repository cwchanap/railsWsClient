class ChangeUserRefInArticles < ActiveRecord::Migration[5.1]
  def change
    remove_reference :articles, :users, foreign_key: true
    add_reference :articles, :user, foreign_key: true
  end
end
