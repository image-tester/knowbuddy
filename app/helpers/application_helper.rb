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
end