class Recipe
  attr_reader :name, :description, :difficulty
  attr_accessor :cooking_time, :done

  # def initialize(name, description)
  #   @name = name
  #   @description = description
  # end

  def initialize(args)
    args.each do |name, value|
      instance_variable_set("@#{name}", value) unless value.nil?
    end
  end
end
