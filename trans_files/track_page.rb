require "open-uri"
require "nokogiri"
require_relative 'recipe'
require 'pry-byebug'

class Parser
  attr_reader :recipe_list
  def initialize(search_term, difficulty = "")
    @search_term = search_term
    @difficulty = difficulty
    @recipe_list = []
    scrape_names
  end

  def scrape_names
    recipes = []
    website = Nokogiri::HTML(open('http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=' + @search_term + @difficulty).read)

    website.search('.m_contenu_resultat').each do |recipe|
      recipe_name = recipe.at('.m_titre_resultat').text.strip
      recipe_description = recipe.at('.m_texte_resultat').text.strip
      recipe_time = recipe.at('.m_detail_time div').text.strip
      recipe_difficulty = recipe.at('.m_detail_recette').text.strip.split(" - ")
      @recipe_list << Recipe.new(recipe_name, recipe_description, recipe_time, recipe_difficulty[2])
    end
  end
end



Parser.new("strawberry")
