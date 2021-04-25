class Relationship < ApplicationRecord
  belongs_to :user
  #follow_idの中身はuser_id（User_idが２つ存在しわからなくなるので、follow_idと命名規則を変更）
  #命名規則を変更しているため、参照するクラスを存在しないFollowクラスから、存在するUserクラスに設定。
  belongs_to :follow, class_name: "User"
end
