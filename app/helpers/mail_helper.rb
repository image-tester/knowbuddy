module MailHelper
  def kiprosh_page_link
    capture do
      link_to 'KIPROSH', 'http://kiprosh.com/',
        {:style=>'color:white; text-decoration:none'}
    end
  end

  def footer_text
    "POWERED BY #{kiprosh_page_link}".html_safe
  end
end
