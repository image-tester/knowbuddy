module PostHelper

  def view_more_activities_link(next_page = 2)
    link_to(
      "View More",
      load_activities_posts_path(page_3: next_page),
      remote: true,
      id: "load_more_link"
    )
  end

  def user_link(user, top = false)
    link_to(
      "#{user.display_name} #{post_count(user, top)}",
      user_posts_posts_path(user_id: user.id)
    )
  end

  def post_count(user, top)
     top ? "(#{user.total})" : ""
  end

  def post_date_link(post)
    link_to(
      timeago_date_format(post.updated_at),
      post_date_posts_path(post_id: post.id),
      remote: true
    )
  end

end
