class Post < ApplicationRecord
    belongs_to :user

    has_one_attached :image

    has_many :post_hash_tags
    has_many :hash_tags, through: :post_hash_tags
    has_many :likes, dependent: :destroy

    after_create :update_likes_count
    after_destroy :update_likes_count
    
    validate :image_presence

    after_commit :create_hash_tags, on: :create

    private 
    def image_presence
        errors.add(:image, "can't be blank") unless image.attached?
    end
    def create_hash_tags
        extract_name_hash_tags.each do |name|
          hash_tags.create(name: name)
        end
    end
    def extract_name_hash_tags
        description.to_s.scan(/#\w+/).map{|name| name.gsub("#", "")}
    end
    def update_likes_count
        update_attribute(:likes_count, likes.count)
    end
end
