
class Auth < Sinatra::Base

  configure do
set :views, File.dirname(__FILE__) + '../views'
pp views
  end

  get '/log_out' do
    session[:user_id] = nil
    unless session[:user_id]
      redirect 'log_in'
    end
  end

  get '/log_in' do
    erb :log_in
  end

  post '/log_in' do
    if session[:user_id]
      redirect "/"
    end

    user = User.authenticate(params[:email], params[:password])

    if user
     session[:user_id] = user.id
     redirect '/'
    else
     redirect "/log_in"
    end
  end
end