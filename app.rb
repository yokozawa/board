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
    @tasks = Task.order("sort_order asc").all
    erb :index
  end

  post '/new' do 
    task = Task.create({:body => params[:body]})
    {:id => task.id, :body => task.body}.to_json
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


