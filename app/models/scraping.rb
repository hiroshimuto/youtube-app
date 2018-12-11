class Scraping
  def self.video_urls
    #スカパー海外/スカサカ/Jリーグ公式/
    urls = ["https://www.youtube.com/channel/UCJe-YHWE_u6LL3DHyv8kXeQ/videos","https://www.youtube.com/channel/UCuC6tBMK3baNzW4PjmY9s8g/videos"]

    urls.each do |url|
      get_video(url)
    end

  end
  def self.get_video(url)
    # オプションの生成(ヘッドレスブラウザで動作するように)
    options = Selenium::WebDriver::Remote::Capabilities
    options = options.chrome('chromeOptions' => { args: ['--headless'] })
    #desired_capabilities:でオプションを指定する
    driver = Selenium::WebDriver.for :chrome,desired_capabilities: options
    # ドライバーの起動 URLへアクセス
    driver.get(url)
    #スクレイピングを実行
    while true do
      #ページスクロール前の高さを取得
      last_height = driver.execute_script("return document.documentElement.scrollHeight")
      #ページをスクロール
      driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
      #指定の秒数待機
      sleep(2)
      #スクロール後の高さを取得
      new_height = driver.execute_script("return document.documentElement.scrollHeight")
      #スクロール前と後で高さが同じ＝これ以上スクロールできない=全ての要素が表示されたら、スクロールを終了
      break if last_height == new_height
      #上記該当しない場合は引き続きスクロール
      last_height = new_height
    end

    #スクロールが終わったらXpathで指定した要素を取得
    video_titles = driver.find_elements(:xpath, "//h3/a['video-title']")
    #Xpathで取得した要素のうちタイトル部分のみ抽出しハッシュを作成
    all_title = video_titles.map{|x| x.attribute('title')}
    #以下同上
    video_links = driver.find_elements(:xpath, "//h3/a['thumbnail']")
    all_link = video_links.map{|x| x.attribute('href').sub(/.*=/,"") }

    each_info = all_title.zip(all_link)

    each_info.each do |info|
      video = Video.where(title: info[0], link: info[1]).first_or_initialize
      video.save
    end

  end

end
