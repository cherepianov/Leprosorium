#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'
#require 'sinatra/reloader'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'create table if not exists Posts
  (
  id integer primary key autoincrement,
  created_date date,
  content text
  )'

end

get '/' do
  #выбираеи список постов из базы данных
  @results = @db.execute 'select * from posts order by id desc'
	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]
  if content.length <= 0
    @error = 'Type post text'
    return erb :new
  end

  #сохранение данных в БД

  @db.execute 'insert into Posts (content, created_date)
 values (?, datetime())', [content]

  redirect to '/'

  erb "You typed: #{content}"
end
