$("body.admin_rules form").ready(function(){
  function toggleScheduleFieldVisibility(){
    if($("#rule_frequency").val() == "daily") {
      $("#rule_schedule").val("");
      $("#rule_schedule_input").hide();
    }
    else{
      $("#rule_schedule_input").show();
    }
  }

  function toggleInputFieldsVisibility(){
    if($(".dropdown.rule_for").val() == "general") {
      $("#rule_min_count, #rule_max_count").val("");
      $("#rule_min_count_input, #rule_max_count_input").hide();
      $("#rule_max_duration_input .label").text("CONTRIBUTION PERIOD");
    }
    else{
      $("#rule_min_count_input, #rule_max_count_input").show();
      $("#rule_max_duration_input .label").text("MAX DURATION");
    }
  }

  function validateNumberField(obj, e){
    var $obj;
    $obj = obj;
    if (e.keyCode >= 59 && !(e.keyCode >= 96 && e.keyCode <= 105)) {
      $obj.val($obj.val().replace(/[^0-9 +-]/g, ""));
    }
  }

  $(window).on("load", function(){
    toggleInputFieldsVisibility();
    toggleScheduleFieldVisibility();
  });

  $(".dropdown.rule_for").change(function(){
    toggleInputFieldsVisibility();
  });

  $("#rule_frequency").change(function(){
    toggleScheduleFieldVisibility();
  });

  $("#rule_min_count").keyup(function(e){
    var obj = $(this);
    validateNumberField(obj, e);
  });

  $("#rule_max_count").keyup(function(e){
    var obj = $(this);
    validateNumberField(obj, e);
  });
});
