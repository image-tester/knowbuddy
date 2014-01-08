ActiveAdmin.register RuleEngine, as: "Rules" do

  filter :name, label: "Name"

  index do
    column :name do |f|
      truncate( f.name, length: 40)
    end
    column :rule_for
    column :min_post
    column :frequency
    column :schedule
    column :mail_for
    column :active

    default_actions
  end

  form do |f|
   f.inputs "Details" do
    f.input :name
    f.input :rule_for, collection: RuleEngine.rule_for_array, include_blank: "-Select-", input_html:{class: 'dropdown rule_for'}
    f.input :min_post, min: 1, input_html:{class: 'min_post'}
    f.object.get_schedule_values
    f.input :mail_for,  collection: RuleEngine.mail_for_array, include_blank: "-Select-", input_html:{class: 'dropdown'}
    f.input :frequency, collection: RuleEngine.frequency_array, include_blank: "-Select-", input_html:{class: 'dropdown'}
    f.input :schedule_time, input_html:{id: "schedule_time"}
    f.input :schedule_day, collection: Date::DAYNAMES, include_blank: false, input_html:{class: 'dropdown'}
    f.input :schedule_date, collection: RuleEngine.date_array, include_blank: false, input_html:{class: 'dropdown'}

    f.input :active
    f.buttons
    end
  end

end
