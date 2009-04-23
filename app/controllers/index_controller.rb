# -*- coding: utf-8 -*-
class IndexController < ApplicationController
  def index
    render :text => 'こんにちわ！ JRuby on Rails on GAE!'
  end
end
