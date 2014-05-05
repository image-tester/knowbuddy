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

  def kyu_link(kyu)
    capture { link_to truncate(kyu.subject, length: 70), kyu_entry_path(kyu) }
  end

  def user_link(user)
    capture { link_to user.display_name, kyu_entries_user_kyu_path(user_id: user.id) }
  end

  def kyu_date_link(kyu)
    capture { link_to (timeago_date_format(kyu.created_at)),
      kyu_entries_kyu_date_path(kyu_id: kyu.id) }
  end
end