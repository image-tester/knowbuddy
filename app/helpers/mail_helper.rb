module MailHelper
  def kiprosh_page_link
    capture { link_to "KIPROSH", KIPROSH_WEBSITE, style: kiprosh_link_style }
  end

  def footer_text
    "POWERED BY #{kiprosh_page_link}".html_safe
  end

  def link_to_post
    capture { link_to "click here", "#{@link_to_post}" }
  end

  def link_text
    "To view this post on knowbuddy portel #{link_to_post}".html_safe
  end

  def kiprosh_link_style
    "color:white; text-decoration:none"
  end

  def activity_owner_link(owner)
    link_to(
      owner.display_name,
      user_posts_posts_url(user_id: owner.id),
      style: "color: #035C78; text-decoration: none"
    )
  end
end
