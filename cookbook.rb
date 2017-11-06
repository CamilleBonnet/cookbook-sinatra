require 'csv'
require_relative 'recipe'

class Cookbook
  # attr_reader :database

  def initialize(path_to_csv_file)
    @database = []
    @csv_options = { col_sep: ',', force_quotes: true }
    @path_to_csv_file = path_to_csv_file
    # creating the database
    load_csv
  end

  def all
    @database
  end

  def add_recipe(recipe)
    @database << recipe
    write_on_csv
  end

  def remove_recipe(recipe_index)
    @database.delete_at(recipe_index)
    write_on_csv
  end

  def remove_all_recipes
    @database = []
    write_on_csv
  end

  def update_recipe
    write_on_csv
  end

  private

  def load_csv
    CSV.foreach(@path_to_csv_file) do |item|
      hash = {
        name:         item[0],
        description:  item[1],
        cooking_time: item[2],
        done:         item[3],
        difficulty:   item[4]
      }
      @database.push(Recipe.new(hash)) unless item[0] == "Name"
    end
  end

  def write_on_csv
    CSV.open(@path_to_csv_file, 'wb', @csv_options) do |csv|
      csv << ["Name", "Description", "Cooking time", "Recipe Done", "difficulty"]
      @database.each do |element|
        csv << [element.name, element.description, element.cooking_time, element.done, element.difficulty]
      end
    end
  end
end
