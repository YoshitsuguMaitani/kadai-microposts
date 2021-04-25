class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    #relationshipsモデルはUser同士の関係であったので、Userにもフォロー関係のコードを記述する。
    #has_many :relationships は、多対多の右半分の「自分がフォローしているUser」への参照
    has_many :relationships
    #has_many :followings という関係を新たに命名する。（フォローしているユーザー達を表現）
    #また、既存のModelクラスでないため（Followingsクラスはない）、取得する情報を後ろに記述。
    #through: :relationships は、has_many :followings の結果を中間テーブルとして指定。
    #source: :follow は、中間テーブルのカラムの中でどれを参照にするidとするかを選択。
    has_many :followings, through: :relationships, source: :follow
    
    #以下のコードは、多対多の左半分の「自分をフォローしているUser」への参照
    #reverses_of_relationship は、relationshipの逆の意味
    #reverses_of_relationship は、勝手に命名したものなので、class_name: "Relationship" で参照するクラスを指定。
    #また、UserクラスからRelationshipクラスを取得する際に、user_idが使用されるが、逆方向の"follow_id"を取得したいので定義
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    def follow(other_user)
      #下のコードは、フォローしようとしているother_userが自分自身でないことを確認し、その次のコードに移る。
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end

    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end

    def following?(other_user)
      #self.followingsにより、フォローしているユーザーを取得し、include?(other_user)でother_userが含まれていないか確認
        self.followings.include?(other_user)
    end
end
