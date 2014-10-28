module MailHelper
  def kiprosh_page_link
    capture do
      link_to "KIPROSH",  "http://kiprosh.com/",
        {style: "color:white; text-decoration:none"}
    end
  end

  def footer_text
    "POWERED BY #{kiprosh_page_link}".html_safe
  end

  def link_to_post
    capture do
      link_to "click here", "#{@link_to_post}"
    end
  end

  def link_text
    "To view this post on knowbuddy portel #{link_to_post}".html_safe
  end
end
