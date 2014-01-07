ActiveAdmin.register RuleEngine do

  filter :name, label: "Name"

  form do |f|
   f.inputs "Details" do
    f.input :name
    f.input :rule_for, collection: RuleEngine.rule_for_array, include_blank: "-Select-", input_html:{class: 'dropdown rule_for'}
    f.input :min_post, min: 1, input_html:{class: 'min_post'}
    f.input :mail_for,  collection: RuleEngine.mail_for_array, include_blank: "-Select-", input_html:{class: 'dropdown'}
    f.input :frequency, collection: RuleEngine.frequency_array, include_blank: "-Select-", input_html:{class: 'dropdown'}
    # f.input :schedule_time, as: :time, include_blank: false, ampm: true
    f.input :schedule_day, collection: Date::DAYNAMES, include_blank: false, input_html:{class: 'dropdown'}
    f.input :schedule_date, as: :select, collection: ((1..30).map {|i| [i,i] }), include_blank: false, input_html:{class: 'dropdown'}

    f.input :active
    f.buttons
    end
  end

end
