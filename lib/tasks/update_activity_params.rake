namespace :activity do
  desc "Remove hardcoded keys from parameters hash"
  task update_parameter_hash_keys: :environment do
    puts "Start..."

    Activity.find_in_batches(:batch_size => 100 ) do |activities|
      activities.each do |activity|
        type = activity.trackable_type
        params = activity.parameters
        case type
        when "User"
          params["user"] = params.delete "1"
        when "KyuEntry", "Post", "Comment"
          if activity.key == 'kyu_entry.newTag'
            params["tag"] = params.delete "1"
          else 
            params["post_subject"] = params.delete "1"
            params["post_id"] = params.delete "2"
          end
        end
        activity.save
      end
    end
    puts "Done"
  end
end