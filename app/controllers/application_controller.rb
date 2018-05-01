require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, "secret_fwitter"
  end

  get '/index' do
    erb :index
  end

  def logged_in?
  end

  def current_user
  end

end
