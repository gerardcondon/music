###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

# Change Compass configuration
# config :development do
  compass_config do |config|
    config.sass_options = {:debug_info => true}
  end
# end

###
# Page options, layouts, aliases and proxies
###

# Slim settings
Slim::Engine.set_default_options :pretty => true
# shortcut
Slim::Engine.set_default_options :shortcut => {
  '#' => {:tag => 'div', :attr => 'id'},
  '.' => {:tag => 'div', :attr => 'class'},
  '&' => {:tag => 'input', :attr => 'type'}
}

# Markdown settings 
#set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet

# Clear out automated posts folder
automated_posts_folder = "#{config[:source]}/posts/automated"
FileUtils.rmtree(automated_posts_folder)
FileUtils.mkdir_p(automated_posts_folder)

post_counter = 1
if data.microposts
  data.microposts.each do |micropost|
    post_content = "---\n"
    post_content += "title: mp#{post_counter}\n"
    post_content += "date: #{micropost.date}\n"
    post_content += "tags: microposts\n"
    post_content += "micropost: true\n"
    post_content += "---\n"
    post_content += "#{micropost.text}"
    
    File.write("#{automated_posts_folder}/#{micropost.date}-mp#{post_counter}.html.md", post_content)
    
    post_counter += 1
  end
end

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)

proxy "/piano.html", "/resources.html",
    :locals => {title: "Piano", resources: data.piano }, :ignore => true

proxy "/guitar.html", "/resources.html",
    :locals => {title: "Guitar", resources: data.guitar }, :ignore => true


###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "chess"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "posts/{type}/{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/sitemap.xml", layout: false

###
# Site Settings
###
# Set site setting, used in helpers / sitemap.xml / feed.xml.
set :site_url, 'https://www.gerardcondon.com/music'
set :site_author, 'Gerard Condon'
set :site_title, 'Music'
set :site_description, 'Site containing resources for piano and Guitar.'
# Select the theme from bootswatch.com.
# If false, you can get plain bootstrap style.
# set :theme_name, 'flatly'
set :theme_name, false
# set @analytics_account, like "XX-12345678-9"
@analytics_account = "UA-124147465-1"

page "/feed.xml", layout: false
page "/diagram.html", layout: :diagram
page "/atom.xml", layout: false
set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :relative_links, true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash
set :relative_links, true

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  signature = "#{Middleman::Deploy::PACKAGE} #{Middleman::Deploy::VERSION}"
  time      = "#{Time.now.utc}"
  deploy.commit_message = "Automated commit at #{time} by #{signature} [ci skip]"
end
