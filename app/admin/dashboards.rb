ActiveAdmin.register_page "Dashboard" do

  users = User.with_deleted
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    span do
      section "Recent Posts", priority: 1 do
        table_for Post.order('id desc').limit(10) do
          column("Subject") {|post| post.subject }
          column("Contributor") {|post| post.user_name }
        end
      end

      section "Posts", priority: 2 do
        table_for User.limit(10) do
          column("Contributor") {|user| user.display_name}
          column("Posts Count") {|user| user.posts.count }
        end
      end

      section "Visits", priority: 3 do
        table_for User.order('sign_in_count desc').limit(10) do
          column("Contributor") {|user| user.display_name }
          column("Visit Count") {|user| user.sign_in_count }
        end
      end
    end
  end
end
