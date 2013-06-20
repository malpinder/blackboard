module ApplicationHelper

  def nav_links
    {
      "Home" => root_path
    }
  end

  def markdown(text)
    markdown_renderer.render(text).html_safe if text.present?
  end

  private
  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, no_intra_emphasis: true, fenced_code_blocks: true, space_after_headers: true)
  end
end
