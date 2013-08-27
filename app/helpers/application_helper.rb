module ApplicationHelper

  def avatar_url(user, size)
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def is_active?(page_name)
    "menu_active" if params[:action] == page_name
  end
end