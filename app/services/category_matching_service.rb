class CategoryMatchingService
  attr_accessor :user, :category_data, :matched_plaid_category, :matched_category, :matched_sub_category

  def initialize(user:, category_data:)
    self.user = user
    self.category_data = category_data
  end

  def run
    match_from_mappings || match_from_name
    self
  end

  private

    def match_from_mappings
      mappings = user.plaid_categories
      return unless mappings

      category_data.length.times do |i|
        hierarchy = category_data[0..(-1 + i)].join(", ")
        match = mappings.find_by_hierarchy(hierarchy)

        if match
          self.matched_plaid_category = match
          break
        end
      end
      matched_plaid_category
    end

    def match_from_name
      query = [category_data.map { |category| "sub_categories.name ILIKE ?" }.join(" OR ")]
      query << category_data.map { |category| "%#{category}%" }
      query.flatten!

      self.matched_sub_category = user.sub_categories.where(query).first

      unless matched_sub_category
        query = category_data.map { |category| "name ILIKE '%#{remove_special_characters(category)}%'" }.join(" OR ")
        self.matched_category = user.categories.where(query).first
      end
    end

    def remove_special_characters(string)
      string.gsub(/[^0-9A-Za-z]/, '')
    end
end
