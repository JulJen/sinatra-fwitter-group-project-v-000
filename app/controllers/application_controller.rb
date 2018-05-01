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

  get '/login' do
   erb :'users/login'
 end

 post '/login' do
   @user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect 'tweets/tweets'
    else
      redirect 'users/failure'
    end
  end

  get '/signup' do
    if logged_in?
      redirect 'tweets/tweets'
    end

    erb :'users/show'
  end

  post '/signup' do
    @user = User.new(:username => params[:username], :password => params[:password])

    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect '/failure'
    elsif @user.save
      redirect 'users/login'
    else
      redirect 'users/failure'
    end
  end

  get '/failure' do
   erb :'users/failure'
 end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/tweets' do

    if logged_in?
      @user = current_user

      erb :'tweets/tweets'
    else
      redirect 'users/failure'
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
