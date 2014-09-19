module ApplicationHelper
  def avatar_url(user, size)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def is_active?(page_name)
    "menu_active" if params[:action] == page_name
  end

  def timeago_date_format(data)
    if(data.to_date > Date.today - 30.days)
      timeago_tag data, nojs: true, limit: 30.days.ago, class: "time_ago"
    else
      data.strftime("%d-%b-%Y")
    end
  end

  def post_link(post)
    link_to truncate(post.subject, length: 70), post_path(post)
  end

  def post_exist?(post)
    post && Post.find(post) rescue false
  end
end


