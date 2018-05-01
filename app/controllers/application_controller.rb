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
      redirect '/tweets'
    elsif !logged_in?
      erb :'users/create_user'
    end
  end

  post '/signup' do

    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect 'users/failure'
    else
      @user = User.create(:username => params[:username], :password => params[:password])
      @user.save
      session[:user_id] = @user.id

      redirect '/tweets'
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
      @user = User.find(session[:user_id])
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if logged_in?
      @tweet = current_user.tweets.create(content: params[:content])
      if @tweet.save
        redirect to "/tweets/#{@tweet.id}"
      else
        redirect to '/tweets/new'
      end
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end




  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by_id(session[:user_id])
    end
  end

end
