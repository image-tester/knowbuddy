ActiveAdmin.register RuleEngine do

  filter :name, label: "Name"

  form do |f|
   f.inputs "Details" do
    f.input :name
    f.input :rule_for, collection: RuleEngine.rule_for_array, include_blank: "-Select-"
    f.input :min_post, min: 1
    f.input :frequency
    f.input :schedule
    f.input :mail_for,  collection: RuleEngine.mail_for_array, include_blank: "-Select-"
    f.input :active
    f.buttons
    end
  end

end
