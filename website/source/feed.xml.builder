xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "#{site_title}"
  xml.subtitle "#{site_description}"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, "music/", current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name site_author }

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.title article.display_title
      xml.link "rel" => "alternate", "href" => site_url + article.url
      xml.id site_url + article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.updated_time
      xml.author { xml.name site_author }
      # xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
