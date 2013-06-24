module SessionHelper

  def example_omniauth_github_response
    omniauth_github_response_for(FactoryGirl.build(:user))
  end

  def omniauth_github_response_for(user)
    OmniAuth::AuthHash.new({
      provider: 'github',
      uid: user.uid,
      info: {
        name: user.name,
        nickname: user.nickname,
        image: user.image_url,
        urls: {"GitHub" => user.github_url}
      }
    })
  end
end