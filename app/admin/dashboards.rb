ActiveAdmin::Dashboards.build do

  section "Recent KYU Entries", :priority => 1 do
    table_for KyuEntry .order('id desc').limit(10) do
      column("Subject") {|kyu_entry| kyu_entry.subject }
      column("Contributor") {|kyu_entry| kyu_entry.user.name.capitalize }
    end
  end

  section "KYU Entries", :priority => 2 do
    table_for User .order('count desc').limit(10) do
      column("Contributor") {|user| user.name.capitalize }
      column("KYU Entry Count") {|user| User.find(user.id).kyu_entries.count }
    end
  end

  section "Visits", :priority => 3 do
    table_for User .order('sign_in_count desc').limit(10) do
      column("Contributor") {|user| user.name.capitalize }
      column("visit count") {|user| user.sign_in_count }
    end
  end
end

