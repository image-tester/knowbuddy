desc "generate slug for existing KYU"
task slug_for_old_KYU: :environment do
   Post.find_each(&:save)
end

