module SessionHelper

  def example_omniauth_github_response
    OmniAuth::AuthHash.new({
      provider: 'github',
      uid: "12345",
      info: {
        name: "Ada L",
        nickame: "ada",
        image: "https://example.gravatar.com/avatar/ada",
        urls: {"GitHub" => "https://example.github.com/ada"}
      }
    })
  end
end