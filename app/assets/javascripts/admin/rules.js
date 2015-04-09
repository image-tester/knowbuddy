$( document ).ready(function(){
  initialize_rules()

  $('#rules_min_count').on("keydown", function(e){
    var key = e.charCode || e.keyCode || 0;
    required_keys = [8, 9, 13, 46];
    return (e.which != 16) ? (required_keys.indexOf(key) != -1) || (key >= 35 && key <= 40) ||
      (key >= 48 && key <= 57) || (key >= 96 && key <= 105) : alert("Enter numbers only");
  });

  // to show and hide input for "Post" and "Activity"
  $('body').on("change", "#rules_rule_for", function(){
    toggle_rule_for_inputs($('.rule_for').val())
  });

  // To show dynamic schedule dropdown
  $('body').on("change", "#rules_frequency", function(){
    hide_schedule_input();
    selected_val = $(this).val();
    toggle_schedule_inputs(selected_val);
  });

  $("#rules_submit_action").on("click", function(){
    return validation();
  });

  function hide_schedule_input(){
   $(".schedule_input").parent().hide()
  }

  function hide_min_count(){
    $("#rules_min_count_input").hide();
    $("#rules_mail_for_input").hide();
  }

  function toggle_rule_for_inputs(selected_val){
    hide_min_count();
    switch(selected_val){
      case "post":
        $("#rules_min_count_input").show();
        $("#rules_min_count_input label").text("Minimum post");
        break;
      case "recent_activities":
        $("#rules_schedule_input").show();
        $("#rules_min_count_input label").text("Select Inactive Days since? ");
        $("#rules_min_count_input").show();
        break;
      case "top_3_contributors":
        $("#rules_mail_for_input").show();
        break;
    }
  }

  function toggle_schedule_inputs(selected_val){
    switch(selected_val) {
      case "weekly":
        $("#rules_schedule_day_input").show();
        break;
      case "monthly":
        $("#rules_schedule_date_input").show();
        break;
    }
  }

  function initialize_rules(){
    hide_schedule_input();
    hide_min_count();
    toggle_rule_for_inputs($("#rules_rule_for").val())
    toggle_schedule_inputs($("#rules_frequency").val());
  }

  var submit = true;
  function validation(){
    $(".rules li input:visible, .rules li select:visible").map(function(){
      return ($("#"+ this.id).val() =="") ?  add_error($("#"+ this.id)) : submit;
    });
  }

  function add_error(e){
    var error = "<p class='inline-errors'> Can't be blank </p>"
    $(e).next('p').remove();
    $(e).after(error);
    submit = false;
  }
})
