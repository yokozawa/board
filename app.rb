require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'addressable/uri'
require 'active_record'
require 'pp'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

class Task < ActiveRecord::Base
end

class MyApp < Sinatra::Base

  get '/' do
    @title = 'Top'
    @tasks = Task.order("sort_order asc").all
    erb :index
  end

  post '/new' do
    Task.create({:body => params[:body]})
    redirect '/'
  end

  post '/update' do
    @ids = params[:ids]
    i=1
    @ids.each do |id|
      task = Task.find(id)
      task.sort_order = i
      i+=1
      task.save
    end
  end

  post '/delete' do
    Task.find(params[:id]).destroy
  end

end


