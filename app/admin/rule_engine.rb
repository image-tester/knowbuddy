ActiveAdmin.register RuleEngine, as: "Rule" do
  filter :rule, label: "Rule"

  index do
    column :rule do |c|
      truncate(c.rule, length: 40)
    end
    column :rule_for
    column :min_count
    column :max_count
    column :frequency
    column :schedule
    column :max_duration
    column :subject
    column :body do |c|
      sanitize(c.body)
    end
    column "Active" do |rule_engine|
      status_tag (rule_engine.active ? "YES" : "NO")
    end
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :rule
      f.input :rule_for,
        collection: RuleEngine.rule_for_array,
        include_blank: "-Select-",
        input_html: { class: "dropdown rule_for" }
      f.input :min_count,
        as: :number,
        min: 0,
        input_html: { class: "min_count" }
      f.input :max_count,
        as: :number,
        min: 1,
        input_html: { class: "min_count" }
      f.input :frequency,
        collection: RuleEngine.frequency_array,
        include_blank: "-Select-",
        input_html: { class: "dropdown" }
      f.input :schedule,
        collection: Date::DAYNAMES,
        include_blank: "-Select-",
        input_html: { class: "dropdown schedule_input" }
      f.input :max_duration,
        collection: RuleEngine.duration_array,
        include_blank: "-Select-",
        input_html: { class: "dropdown schedule_input" }
      f.input :subject,
        as: :text,
        input_html: { class: "text" }
      f.input :body,
        as: :text,
        input_html: { class: "text" }
      f.input :active
      f.actions do
        f.action :submit, label: change_button_caption(params),
          wrapper_html: { class: "rule-engine-submit-button" }
        f.action :cancel, label: "Cancel", wrapper_html: { class: "cancel" }
      end
    end
  end

  permit_params :frequency, :subject, :body, :min_count, :max_count,
    :rule, :rule_for, :max_duration, :schedule, :active
end
