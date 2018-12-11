class HomeController < ApplicationController
#-*- coding: utf-8 -*-
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
require 'uri'
require 'selenium-webdriver'

def index
  # URL生成
  url = "https://www.youtube.com/playlist?list=PLEfXwIkfHxL8b2bjvHFjb-6rNYp8IWV9B"
  # オプションの生成(ヘッドレスブラウザで動作するように)
  options = Selenium::WebDriver::Remote::Capabilities
  options = options.chrome('chromeOptions' => { args: ['--headless'] })
  #desired_capabilities:でオプションを指定する
  driver = Selenium::WebDriver.for :chrome,desired_capabilities: options
  # ドライバーの起動 URLへアクセス
  driver.get(url)

    while true do

      last_height = driver.execute_script("return document.documentElement.scrollHeight")

      driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")

      sleep(1)

      new_height = driver.execute_script("return document.documentElement.scrollHeight")

      break if last_height == new_height

      last_height = new_height

    end

    video_titles = driver.find_elements(:xpath, "//h3/a['video-title']")
    @video_titles = video_titles.map{|x| x.attribute('title')}

  end

end
