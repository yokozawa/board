require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'addressable/uri'
require 'active_record'
require 'json'
require 'pp'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

class Task < ActiveRecord::Base
end

class UserToBoard < ActiveRecord::Base
end


class MyApp < Sinatra::Base

  configure do
    enable :logging, :dump_errors
    set :raise_errors, true
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  after do
    ActiveRecord::Base.connection.close
  end

  get '/' do
    @title = 'Top'
    board_id = params[:board_id];
    board_id = 1 if !board_id;
    @tasks = Task.where(:board_id => board_id).order("sort_order asc").all
    @board_id = board_id;

    @u2bs = UserToBoard.where(:user_id => 1).order("board_id asc").all;
    erb :index
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


