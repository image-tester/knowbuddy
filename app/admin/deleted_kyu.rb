ActiveAdmin.register KyuEntry, as: "Deleted KYU Entries" do
  scope :Deleted_KYU, default: true do |kyu|
    kyu = KyuEntry.only_deleted
  end

  menu priority: 2

  actions :all, except: [:edit, :new]

  filter :subject
  filter :user , as: :select,
                 collection: User.with_deleted.user_collection_email_name

    form do |f|
      f.inputs "Details" do
        f.input :user,
                collection: User.with_deleted.user_collection_email_name
        f.input :content
        f.input :publish_at
        f.input :slug
      end
      f.buttons
    end

  index do
    id_column
    column :subject
    column :user do |user|
      User.with_deleted.find(user.user_id).name || User.with_deleted.
                                                   find(user.user_id).email
    end
    column :publish_at
    column "Actions" do |kyu|
      raw "#{link_to 'View', controller: "admin/deleted_kyu_entries",
                          action: "deleted_kyu", id: kyu.id}
           #{link_to 'Delete', admin_kyu_entry_path(kyu), method: :delete,
      confirm: "Are you sure you want to delete this KYU Entry permanently ?"}
           #{link_to 'Restore', controller: "admin/deleted_kyu_entries",
                          action: "restore", id: kyu.id}"
    end
  end

  controller do
    def restore
      KyuEntry.only_deleted.where("id = ?", params["id"]).first.recover
      flash[:notice] = "KYU Entry was successfully restored"
      redirect_to controller: "admin/kyu_entries", action: "index"
    end

    def deleted_kyu
      @kyu_entry = KyuEntry.with_deleted.where("id = ?", params["id"]).first
    end
  end
end

