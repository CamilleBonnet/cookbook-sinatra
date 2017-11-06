require_relative 'parsing'

class View
  # need no use the attribute for a view

  def add_recipe
    puts ""
    puts "What is the name of the recipe?"
    name = gets.chomp.to_s
    puts ""
    puts "Describe a little bit more your recipe!"
    description = gets.chomp.to_s
    [name, description]
  end

  # should only receive the database
  def list(database, new = 0)
    puts ""
    puts "Here the #{new == 1 ? 'new ' : ''}list of your recipes:"
    database.each_with_index do |item, index|
      done = item.done == "" || item.done.nil? ? " " : "X"
      puts "#{index + 1}: [#{done}] #{item.name}"
      puts "       => #{item.description}"
      puts "       => #{item.cooking_time}"
      puts "       => #{item.difficulty}"
      puts ""
    end
  end

  def index_to_remove(size)
    puts "Which recipe do you want to remove ?"
    puts "    Type ALL do delete all items"
    choice = gets.chomp
    choice.upcase == "ALL" ? -1 : good_choice(choice.to_i, 1, size) - 1
  end

  def index_to_update(size)
    puts "Which recipe do you want to update ?"
    good_choice(gets.chomp.to_i, 1, size) - 1
  end

  def import_recipe_choose_site
    # Choose the website to search a recipe
    puts ""
    puts "On what web site do you want to search ?"
    puts "    PRESS 1   =>  Marmiton.org"
    puts "    PRESS 2   =>  LetsCookFrench.com"
    good_choice(gets.chomp.to_i, 1, 2)
  end

  def import_recipe_choose_ingredient
    puts ""
    puts "With what ingredient do you want to choose a recipe?"
    puts "  (during tests: chocolate, fraise or strawberry)"
    gets.chomp.to_s
  end

  def import_recipe_select_recipe(list_of_recipes)
    # The user select the recipe he wants to save
    puts ""
    puts "Which recipe do you want to save in your Cookbook?"
    list_of_recipes.each_with_index do |value, index|
      puts "    #{index + 1} => #{value[0]}"
    end
    good_choice(gets.chomp.to_i, 1, list_of_recipes.size)
  end

  def database_empty
    puts "No action possible!"
    puts "The list of recipes is empty!"
  end

  private

  def good_choice(choice, begin_of_choice, end_of_choice)
    until (begin_of_choice..end_of_choice).cover?(choice)
      puts ""
      puts "Please enter a number between 1 and #{end_of_choice}:"
      choice = gets.chomp.to_i
    end
    choice
  end
end
