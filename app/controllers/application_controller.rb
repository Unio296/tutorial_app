class ApplicationController < ActionController::Base  #アプリケーションコントローラ
  protect_from_forgery with: :exception

  def hello
    render html: "hello, world!"
  end
end