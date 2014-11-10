namespace :populate do
  desc "Populate activity type data"
  task activity_types: :environment do
    puts "Start rake task..."
    [
      [activity_type: 'post.create', is_active: true],
      [activity_type: 'post.update', is_active: true],
      [activity_type: 'post.destroy', is_active: true],
      [activity_type: 'comment.create', is_active: true],
      [activity_type: 'comment.update', is_active: true],
      [activity_type: 'comment.destroy', is_active: true],
      [activity_type: 'user.create', is_active: true],
      [activity_type: 'post.newTag', is_active: true],
      [activity_type: 'post.like', is_active: true],
      [activity_type: 'post.dislike', is_active: true]
    ].each do |activity|
      ActivityType.create(activity)
      puts "Actvity type #{activity[0].flatten[1]} is created."
    end
    puts "End rake task..."
  end

  desc "Update existing activity_type for Post"
  task update_activity_types: :environment do
    puts "Start rake task..."
    post_activities = ActivityType.where("activity_type LIKE ?",  "kyu_entry%")
    post_activities.each do |activity|
      activity_type = activity.activity_type.gsub!("kyu_entry", "post")
      activity.update_column(:activity_type, activity_type)
      puts "Update activity_type#{activity.id}"
    end
    puts "End rake task..."
  end

  # rake populate:vote_activity_types
  desc "Voye Activities"
  task vote_activity_types: :environment do
    puts "Start rake task..."
    [
      [activity_type: 'post.like', is_active: true],
      [activity_type: 'post.dislike', is_active: true]
    ].each do |activity|
      ActivityType.create(activity)
      puts "Actvity type #{activity[0].flatten[1]} is created."
    end
    puts "End rake task..."
  end
end
