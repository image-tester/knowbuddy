$( document ).ready(function(){
  initialize_rules()

  $("#schedule_time").ptTimeSelect({
    hoursLabel: 'HRS'
  });

  // to show and hide input for "Post" and "Activity"
  $(".rule_for").live("change", function(){
    toggle_rule_for_inputs($('.rule_for').val())
  });

  // To show correct schedule dropdown
  $("#rules_frequency").live("change", function(){
    hide_schedule_inputs();
    selected_val = $(this).val();
    toggle_schedule_inputs(selected_val);
  });

  $("#rules_submit").live("click", function(){
    return validation();
  });

  function hide_schedule_inputs(){
    $("#rules_schedule_time_input, #rules_schedule_day_input, #rules_schedule_date_input").hide();
  }

  function toggle_rule_for_inputs(selected_val){
    $("#rules_mail_for_input").hide();
    $("#rules_min_post_input").hide();
    switch(selected_val){
    case "post":
      $("#rules_min_post_input").show();
      break;
    case "activity":
      $("#rules_mail_for_input").show();
      break;
    }
  }

  function toggle_schedule_inputs(selected_val){
    switch(selected_val)
    {
    case "daily":
      $("#rules_schedule_time_input").show();
      break;
    case "weekly":
      $("#rules_schedule_day_input").show();
      break;
    case "monthly":
      $("#rules_schedule_date_input").show();
      break;
    }
  }

  function initialize_rules(){
    hide_schedule_inputs()
    selected_rule_for_val = $("#rules_rule_for").val();
    toggle_rule_for_inputs(selected_rule_for_val)

    selected_frequency_val = $("#rules_frequency").val();
    toggle_schedule_inputs(selected_frequency_val);
  }

  function validation(){
    submit = true;
    error = "<p class='inline-errors'> Can't be blank </p>"

    min_post_not_valid = $("#rules_min_post").is(":visible") && $("#rules_min_post").val() == ""
    rule_for_not_valid = $("#rules_mail_for").is(":visible") && $("#rules_mail_for").val() == ""

    schedule_time_not_valid = $("#schedule_time").is(":visible") && $("#schedule_time").val() == ""

    schedule_day_not_valid = $("#rules_schedule_day").is(":visible") && $("#rules_schedule_day").val() == ""

    schedule_date_not_valid = $("#rules_schedule_date").is(":visible") && $("#rules_schedule_date").val() == ""

    if(min_post_not_valid)
    {
      add_error($("#rules_min_post"))
      submit = false;
    }

    if(rule_for_not_valid)
    {
      add_error($("#rules_mail_for"))
      submit = false;
    }
    if(schedule_time_not_valid){
      add_error($("#schedule_time"))
      submit = false;
    }
    if(schedule_day_not_valid){
      add_error($("#rules_schedule_day"))
      submit = false;
    }
    if(schedule_date_not_valid){
      add_error($("#rules_schedule_date"))
      submit = false;
    }
    return submit;
  }

  function add_error(e){
    $(e).next('p').remove();
    $(e).after(error)
  }
})
