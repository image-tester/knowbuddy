// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
// Added on 21st April 2012 by yatish to delete tags on dblclick
// Start  
$(document).ready(function(){
$("div.kyuContent span#kyu-tag").dblclick(function(){ 
var tag = $(this).text().trim();
var id = $(this).parent().attr("kyu_id");
var temp = $(this);
$.ajax({
       type: "POST",
       url: "/kyu_entries/remove_tag",
       dataType: "json",
       data: {"id": id, "tag": tag}, 
       success: function (html) {
                temp.hide();
             },
       error: function (html) {
                alert('error');
             }
       });
      
  });
});
// End


