$(document).ready(function(){

  var post_id = $("#post-subject").data('id');

  $('body').on('click',".voterDetails i:not('.voted')", function(event) {
    $.ajax({
      type: "POST",
      dataType: "JSON",
      url: "/posts/assign_vote",
      data: { id: post_id, vote_type: event.target.id },
      success: function(data){
        $(".up_rate .vote").html(data["likes"]);
        $(".down_rate .vote").html(data["dislikes"]);
        $(".voterDetails i").removeClass('voted');
        $(event.target).addClass('voted');
      }
    });
  });
});
