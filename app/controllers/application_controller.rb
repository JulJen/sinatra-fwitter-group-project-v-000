require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, "secret_fwitter"
  end

  get '/' do
    erb :index
  end

  get "/signup" do
    if logged_in?
      redirect '/tweets'
    end

    erb :'users/create_user'
  end

  post "/signup" do
    #your code here

    user = User.new(:username => params[:username], :password => params[:password])

    if user.username == ""
      redirect "/failure"
    elsif user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
