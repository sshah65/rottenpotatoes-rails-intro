class Movie < ActiveRecord::Base
    def Movie.ratings
        ratings=Movie.all.collect{|single| single.rating}
        ratings.uniq!
        ratings.sort!
    end
end
