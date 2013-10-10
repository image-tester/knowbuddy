namespace :populate do
  desc "Populate activity type data"
  task activity_types: :environment do
    puts "Start rake task..."
    [
      [activity_type: 'kyu_entry.create', is_active: true],
      [activity_type: 'kyu_entry.update', is_active: true],
      [activity_type: 'kyu_entry.destroy', is_active: true],
      [activity_type: 'comment.create', is_active: true],
      [activity_type: 'comment.update', is_active: true],
      [activity_type: 'comment.destroy', is_active: true],
      [activity_type: 'user.create', is_active: true],
      [activity_type: 'kyu_entry.newTag', is_active: true]
    ].each do |activity|
      ActivityType.create(activity)
      puts "Actvity type #{activity[0].flatten[1]} is created."
    end
    puts "End rake task..."
  end
end