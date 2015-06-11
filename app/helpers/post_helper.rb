module PostHelper

  def view_more_activities_link(next_page = 2)
    link_to(
      "View More",
      load_activities_posts_path(page_3: next_page),
      remote: true,
      id: "load_more_link"
    )
  end

  def top_user_link(top_user)
    link_to(
      "#{top_user.display_name} (#{top_user.total})",
      user_posts_posts_path(user_id: top_user.id, post_count: top_user.total)
    )
  end

  def user_link(user)
    link_to(
      "#{user.display_name}",
      user_posts_posts_path(user_id: user.id)
    )
  end

  def post_date_link(post)
    date = post.is_draft? ? post.created_at : post.publish_at
    link_to(
      timeago_date_format(date),
      post_date_posts_path(post_id: post.id),
      remote: true
    )
  end
end
