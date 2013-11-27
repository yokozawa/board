require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'active_record'
require 'json'
require 'pp'
require 'koala'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

class Task < ActiveRecord::Base
end

class UserToBoard < ActiveRecord::Base
  belongs_to:board
  belongs_to:user
end

class Board < ActiveRecord::Base
  has_many:tasks
  has_many:user_to_boards
  has_many:users, :through => :user_to_boards
#  attr_accessible:user_ids
end

class User < ActiveRecord::Base
  has_many:user_to_boards
  has_many:boards, :through => :user_to_boards
#  attr_accessible:board_ids
end

class MyApp < Sinatra::Base

  use Rack::Session::Cookie, :expire_after => 60*60*3, :secret => 'xxxx'

  configure do
    ENV['APP_ID'] = "590797490990322"
    ENV['APP_SECRET'] = "c312a380c87089ab9aa85319ad0eb1dc"
    set :sessions, true
    enable :sessions, :logging, :dump_errors
    register Sinatra::Reloader
    set :raise_errors, true
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  def base_url
    "#{request.scheme}://#{request.host}:#{request.port.to_s}"
  end

  before do
    if session[:facebook_access_token]
      @graph = Koala::Facebook::API.new(session[:facebook_access_token])
    else
      @graph = nil
    end
  end

  after do
    ActiveRecord::Base.connection.close
  end

  def oauth_consumer
    Koala::Facebook::OAuth.new(ENV['APP_ID'],ENV['APP_SECRET'])
  end

  get '/' do
    if @graph == nil
      redirect '/request_token'
    end
    @me = @graph.get_object('me')
    @title = 'Top'
    board_id = params[:board_id]
    board_id = 1 if !board_id
    @tasks = Task.where(:board_id => board_id).order("sort_order asc").all
    @board_id = board_id
    @u2bs = UserToBoard.where(:user_id => 1).order("board_id asc").all
    erb :index
  end

  get '/request_token' do
    callback_url = "#{base_url}/access_token"
    Koala::Facebook::OAuth.new(ENV['APP_ID'], ['APP_SECRET'], callback_url)
    redirect oauth_consumer.url_for_oauth_code(:callback => callback_url)
  end

  get '/access_token' do
    if params[:code]
      callback_url = "#{base_url}/access_token"
      session[:facebook_access_token] = oauth_consumer.get_access_token(params[:code], :redirect_uri => callback_url)
      redirect '/'
    end
  end

  post '/new' do 
    max = Task.maximum(:sort_order) + 1
    task = Task.create({:body => params[:body], :board_id => params[:board_id], :sort_order => max})
    {:id => task.id, :body => task.body, :sort_order => task.sort_order}.to_json
  end

  post '/sort' do
    @ids = params[:ids]
    i=1
    @ids.each do |id|
      task = Task.find(id)
      task.sort_order = i
      i+=1
      task.save
    end
  end

  post '/edit' do
    id = params[:pk]
    task = Task.find(id)
    task.body = params[:value]
    task.save
  end

  post '/delete' do
    Task.find(params[:id]).destroy
  end

end


