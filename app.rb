require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "sqlite3"
require_relative "app/models/parse"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/translations.sqlite'))

set :views, (proc { File.join(root, "views") })
set :bind, '0.0.0.0'

get '/' do
  erb :index # Do not remove this line
end

post '/tranlsation' do
  # binding.pry
  word = params[:word]
  @translation = Parse.search(word)
  erb :output
end

get "/translation-list" do
  @translations = DB.execute("SELECT * FROM translations;")
  erb :translations
end
