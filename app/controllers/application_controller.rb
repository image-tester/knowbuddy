class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, if: Proc.new {
    return !(params[:controller].include? "admin") }

  helper_method :tag_cloud

  private
  # def after_sign_out_path_for(resource_or_scope)
  #   scope = Devise::Mapping.find_scope!(resource_or_scope)
  #   send(:"new_#{scope}_session_path")
  # end

# Added on 23rd April 2012 by yatish to display cloud tag
# Start
   def tag_cloud
    tags = KyuEntry.tag_counts.order('count Desc').limit(20)
    if tags.length > 0
      maxOccurs = tags.first.count
      minOccurs = tags.last.count
      minFontSize = 10
      maxFontSize = 23
      @tag_cloud_hash = Hash.new(0)
      tags.each do |tag|
        weight = (tag.count-minOccurs).to_f/(maxOccurs-minOccurs)
        size = minFontSize + ((maxFontSize-minFontSize)*weight)
        @tag_cloud_hash[tag] = size if size > 4
      end
     end
   end
# End
end

