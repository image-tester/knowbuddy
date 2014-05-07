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

  desc "Update trackable_type KyuEntry to Post and respective keys"
  task update_trackable_type_with_keys: :environment do
    puts "Start"
    post_activities = Activity.where(trackable_type: "KyuEntry")
    post_activities.find_in_batches(batch_size: 100) do |activities|
      activities.each do |activity|
        activity.key = activity.key.gsub!("kyu_entry", "post")
        activity.trackable_type = "Post"
        activity.save
      end
    end
    puts "Done"
  end
end
