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

    if @user && @user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
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
    if logged_in?
      redirect '/tweets'
    end
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect '/signup'
    else
      @user = User.create(:username => params[:username], :password => params[:password])
      @user.save
      session[:user_id] = @user.id

      redirect '/tweets'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
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
      @tweet = Tweet.create(content: params[:content], user_id: current_user.id)
      if params[:content] != ""
        redirect to '/tweets/new'
      else
        redirect to "/tweets/#{@tweet.id}"
      end
    elsif !logged_in?
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.update(content: params[:content])
      if !params[:content].empty?
        @tweet.save
        redirect "/tweets/#{@tweet.id}"
      end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in? && current_user == @tweet.user_id
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.delete
      redirect '/tweets'
    elsif !logged_in?
      redirect "/login"
    else
      redirect "/tweet/#{@tweet.id}"
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
