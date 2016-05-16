require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"


# get "/" do
#   @files = Dir.glob("public/*")
#   @files.map! do |file| 
#       File.basename(file)
#   end
#   if params[:sort] == "d"
#     @files = @files.reverse
#   end
  
#   erb :list
# end
not_found do
 #{}"The page could not be found"
 redirect "/"
end



helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
  end

  def highlight(text, term)
    text.gsub(term, %(<strong>#{term}</strong>))
  end

end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/chapters/:number" do
  #@contents = File.readlines("data/toc.txt")
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  @title = "Chapter #{number} : #{chapter_name}"
  
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end

get "/search" do

  if params[:query]
    @results = @contents.each_with_index.select do |_,index |
      text = File.read("data/chp#{index + 1}.txt")
      paragraphs = text.split("\n\n")
      paragraphs.any? do |p|
           p.include?(params[:query])
      end
    end
  end
  erb :search
end


get "/" do
  @title = "The Adventures of Sherlock Holmes"
  #@contents = File.readlines("data/toc.txt")

  erb :home
end