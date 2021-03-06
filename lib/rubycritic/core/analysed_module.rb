require "virtus"
require "rubycritic/core/rating"

module Rubycritic

  class AnalysedModule
    include Virtus.model

    attribute :name
    attribute :pathname
    attribute :smells,        Array,   :default => []
    attribute :churn
    attribute :committed_at
    attribute :complexity
    attribute :duplication,   Integer, :default => 0
    attribute :methods_count

    def path
      @path ||= pathname.to_s
    end

    def cost
      @cost ||= smells.map(&:cost).inject(0, :+) + (complexity / 25)
    end

    def rating
      @rating ||= Rating.from_cost(cost)
    end

    def complexity_per_method
      if methods_count == 0
        "N/A"
      else
        complexity.fdiv(methods_count).round(1)
      end
    end

    def smells?
      !smells.empty?
    end

    def smells_at_location(location)
      smells.select { |smell| smell.at_location?(location) }
    end
  end

end
