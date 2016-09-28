class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director,
                :genre, :runtime, :synopsis, :failure
  def scrape_new_movie(url)
    begin
      doc = Nokogiri::HTML(open(url))
      doc.css('script').remove
      self.title = doc.at('//h1').text.strip
      self.hotness = doc.at_css('span.meter-value').text[0,doc.at_css('span.meter-value').text.index('%')].to_i
      self.image_url = doc.at_css('#movie-image-section img')['src']
      self.rating = doc.at_css('div.info > div:nth-child(2)').text
      self.director = doc.at_css('div.info > div:nth-child(6)').text.strip
      self.genre = doc.at_css('div.info > div:nth-child(4)').text.strip
      self.runtime = doc.at_css('div.info > div:nth-child(14)').text.strip
      s = doc.css('#movieSynopsis').text.strip
      if !s.valid_encoding?
        s= s.encode('UTF-16be', :invalid=>:replace, :replace=>'?').encode('UTF-8')
      end
      self.synopsis = s
      return true
    rescue Exception => e
      self.failure = 'Something went wrong getting the information'
    end
  end

end