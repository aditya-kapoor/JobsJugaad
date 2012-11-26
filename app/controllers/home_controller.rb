class HomeController < ApplicationController
  def index
  end

  caches_page :faqs
  def faqs
  end
end
