module ApplicationHelper

  def wiki_text(text)
    RedCloth.new(text, [:filter_html, :filter_styles]).to_html
  end
  
end
