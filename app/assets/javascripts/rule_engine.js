$(document).ready(function(){
  $('.dropdown.rule_for').change(function(){
    if($('.dropdown.rule_for').val() == 'general') {
      $('#rule_min_count_input').hide();
      $('#rule_max_count_input').hide();
      $('#rule_max_duration_input').hide();
    }
    else{
      $('#rule_min_count_input').show();
      $('#rule_max_count_input').show();
      $('#rule_max_duration_input').show();
    }
  });

  $('#rule_frequency').change(function(){
    if($('#rule_frequency').val() == 'daily') {
      $('#rule_schedule_input').hide();
    }
    else{
      $('#rule_schedule_input').show();
    }
  });

  $('#rule_min_count').keyup(function(e) {
    obj = $(this)
    validate_number_field(obj, e);
  });

  $('#rule_max_count').keyup(function(e) {
    obj = $(this)
    validate_number_field(obj, e);
  });

  function validate_number_field(obj, e) {
    var $obj;
    $obj = obj;
    if (e.keyCode >= 59 && !(e.keyCode >= 96 && e.keyCode <= 105)) {
      $obj.val($obj.val().replace(/[^0-9 +-]/g, ''));
    }
  }
});
