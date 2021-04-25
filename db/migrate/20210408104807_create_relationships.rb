class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      #t.referencesは別のテーブルを参照するの意味
      t.references :user, foreign_key: true
      #follow_idにはuserテーブルを参照させたいので、{ to_table: :users }によって、外部キーとしてusersテーブルを参照している。
      #{ to_table: :users }をつけずに行うと、followsテーブルを参照しようとしてエラーがでる。
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      #user_idとfollow_idが重複しないようにする。（フォローするUserとフォローされるUserは必ず異なる）
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
