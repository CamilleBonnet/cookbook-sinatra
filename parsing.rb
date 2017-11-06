require 'open-uri'
require 'nokogiri'

class Parsing
  def self.site_selection(number)
    case number
    when 1
      ["http://www.marmiton.org", "http://www.marmiton.org/recettes/recherche.aspx?aqt="]
      # ["http://www.marmiton.org", "lib/html/"]
      #
    when 2
      ["http://www.letscookfrench.com", "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt="]
      # ["http://www.letscookfrench.com", "lib/html/"]
    end
  end

  def self.list_recipes_from_web(ingredient)
    doc = Nokogiri::HTML(open(ingredient), nil, 'utf-8')

    # FOR TESTS /!\
    # doc = Nokogiri::HTML(File.open(ingredient + ".html"), nil, 'utf-8')
    # FOR TESTS /!\
    list_found = []
    doc.search(".m_titre_resultat > a").each do |element|
      list_found.push([element.text, element['href']])
    end
    list_found
  end

  def self.cooking_difficulty(recipe)
    # doc = Nokogiri::HTML(File.open(recipe), nil, 'utf-8')
    doc = Nokogiri::HTML(open(recipe), nil, 'utf-8')
    if recipe.include?("marmiton")
      cooking = "Prep and cooking time: " + doc.search(".recipe-infos__total-time__value").text
      difficulty = doc.search(".recipe-infos__item-title")[2].text
    else
      cooking = cooking_time_parsing(doc)
      difficulty = difficulty_parsing(doc)
    end
    { cooking: cooking, difficulty: difficulty }
  end

  # private

  def self.cooking_time_parsing(doc)
    prep = doc.search(".preptime").text
    cook = doc.search(".cooktime").text
    prep = prep == "" ? "" : "Prep.: " + prep + "min"
    cook = cook == "" ? "" : " - Cook.: " + cook + "min"
    prep + cook
  end

  def self.difficulty_parsing(doc)
    string = doc.search(".m_content_recette_breadcrumb").text
    string.split(/(^.*$)/)[5].strip
  end
end
