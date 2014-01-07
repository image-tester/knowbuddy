$( document ).ready(function(){
hide_schedule_inputs()
$("#rule_engine_mail_for_input").hide();
$("#rule_engine_min_post_input").hide();
$(".rule_for").live("change", function(){
  selected_val = $('.rule_for').val();

  $("#rule_engine_min_post_input").hide();
  $("#rule_engine_mail_for_input").hide();
  switch(selected_val){
  case "post":
    $("#rule_engine_min_post_input").show();
    break;
  case "activity":
    $("#rule_engine_mail_for_input").show();
    break;
  }
});

$("#rule_engine_frequency").live("change", function(){
  hide_schedule_inputs();
  selected_val = $(this).val();
  switch(selected_val)
  {
  case "daily":
    $("#rule_engine_schedule_time_input").show();
    break;
  case "weekly":
    $("#rule_engine_schedule_day_input").show();
    break;
  case "monthly":
    $("#rule_engine_schedule_date_input").show();
    break;
  }
});

function hide_schedule_inputs(){
  $("#rule_engine_schedule_time_input, #rule_engine_schedule_day_input, #rule_engine_schedule_date_input").hide();
}
})
