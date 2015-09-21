class Movie < ActiveRecord::Base
  def self.get_ratings
    all_ratings = Movie.uniq.pluck(:rating)
  end
end
