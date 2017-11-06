require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end


cookbook = Cookbook.new("recipes.csv")


get '/' do
  @usernames = [ 'ssaunier', 'Papillard' ]
  erb :index
end

get '/about' do
  erb :about
end

get '/team/:username' do
  binding.pry  # <= code will stop here for HTTP request localhost:4567/team/someone
  puts params[:username]
  "The username is #{params[:username]}"
end


get '/cookbook' do

  @recipies = cookbook.all
  erb :cookbook
end
