require_relative 'view'
require_relative 'recipe'


class Controller
  def initialize(cookbook)
    @view = View.new
    @cookbook = cookbook
  end

  def list
    # @cookbook.all
    @view.list(@cookbook.all)
  end

  def create
    # We need to get the name of the recipie1
    n_and_d = @view.add_recipe
    recipe = Recipe.new(name: n_and_d[0], description: n_and_d[1])
    @cookbook.add_recipe(recipe)
  end

  def destroy
    if !@cookbook.all.empty?
      @view.list(@cookbook.all)
      index = @view.index_to_remove(@cookbook.all.size)
      index == -1 ? @cookbook.remove_all_recipes : @cookbook.remove_recipe(index)
      @view.list(@cookbook.all, 1) unless index == -1
    else
      @view.database_empty
    end
  end

  def destroy_all
    @cookbook.remove_all_recipe
  end

  def import
    # choose the web site to parse
    web_site_choice = @view.import_recipe_choose_site
    # choose the ingredient to search on the web
    ingredient = @view.import_recipe_choose_ingredient
    # parse the the web site
    web_site = Parsing.site_selection(web_site_choice)
    list_of_recipes = Parsing.list_recipes_from_web(web_site[1] + ingredient)
    # choose the recipe to add to the list
    choice_recipe = @view.import_recipe_select_recipe(list_of_recipes)
    n_and_d = [list_of_recipes[choice_recipe - 1][0], web_site[0] + list_of_recipes[choice_recipe - 1][1]]
    c_and_dif = Parsing.cooking_difficulty(n_and_d[1])
    hash_recipe = { name: n_and_d[0], description: n_and_d[1],
                    cooking_time: c_and_dif[:cooking], difficulty: c_and_dif[:difficulty] }
    @cookbook.add_recipe(Recipe.new(hash_recipe))
  end

  def recipe_done
    if !@cookbook.all.empty?
      @view.list(@cookbook.all)
      index = @view.index_to_update(@cookbook.all.size)
      update_mark = @cookbook.all[index].done == "" || @cookbook.all[index].done.nil? ? "X" : ""
      @cookbook.all[index].done = update_mark
      @cookbook.update_recipe
      @view.list(@cookbook.all, 1)
    else
      @view.database_empty
    end
  end
end
