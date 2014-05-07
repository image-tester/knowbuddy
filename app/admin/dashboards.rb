ActiveAdmin::Dashboards.build do

  users = User.with_deleted

  section "Recent Posts", priority: 1 do
    table_for Post.order('id desc').limit(10) do
      column("Subject") {|post| post.subject }
      column("Contributor") {|post| post.user.name || post.user.email }
    end
  end

  section "Posts", priority: 2 do
    table_for User.limit(10) do
      column("Contributor") {|user| user.name || user.email}
      column("Posts Count") {|user| user.posts.count }
    end
  end

  section "Visits", priority: 3 do
    table_for User.order('sign_in_count desc').limit(10) do
      column("Contributor") {|user| user.name || user.email}
      column("visit count") {|user| user.sign_in_count }
    end
  end
end

