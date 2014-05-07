$(document).ready(function(){

  $('#textarea_kyu_content').markItUp(mySettings);
  $("#formID1").validationEngine();

  function preview() {
  $("#previewlink").click(function(e) {
    $(this).facebox();
    var strDefaultValForKYUTextarea = "h1. This is Textile markup. Give it a try! \n \n A *simple* paragraph with a line break, some _emphasis_ and a \"link\":http://redcloth.org \n\n * an item \n * and another \n\n # one \n # two";
    var content = $(".text_area").val();
    if(content == strDefaultValForKYUTextarea)
    { content = "";
      $("#textarea_kyu_content").validationEngine('validate');
      $(this).stopPropagation();
    }
    else {
      $.ajax({
        type: 'POST',
        url: '/posts/parse_content',
        data: { divcontent: content},
        dataType: 'json',
        success: function(data){
          $("#default_preview").html(data);
          jQuery.facebox({ div: '#default_preview' });
       },
       error: function(error) { alert(error)}
    });}
  });
  }
  $("#formIDRegi").validationEngine({
  'customFunctions': {
      'checkEmail': function (field, rules, i, options){
          if ($('#emailvalidate').val() == "") {
              return options.allrules.required.alertText;
          }
          else {
            var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
            if (!filter.test($('#emailvalidate').val())) { return options.allrules.email.alertText; }
          }
        }
      }
  });

  var mylist = $('#namelist');
  var listitems = mylist.children('li').get();
  listitems.sort(function(a, b) {
    return $(a).text().toUpperCase().localeCompare($(b).text().toUpperCase());
  })
  $.each(listitems, function(idx, itm) { mylist.append(itm); });
  //Ajaxify posting comment
  //start
  $("#new_comment").validationEngine({
    'customFunctions': {
      'checkContent': function (field, rules, i, options){
        if ($('#comment_comment').val() == '') {
          return options.allrules.required.alertText;
        }
      }
    }
  });

  $('body').on('ajax:success', '#new_comment', function(xhr, data, status) {
    $("#latest_comment").prepend(data.new_comment).fadeOut(200).fadeIn(2000)
    $('#comment_comment').val('')
    $("time.comment_time_ago").timeago();
  });
  //end


  //File Preview icon display
  //start
  function makeflieupload() {
    $('#fileupload').fileupload({
      url: '/attachments',
      dataType: 'json',
      add: function (e, data) {
        $('#load').attr("src",'/assets/loading.gif')
        $('#load').show()
        var fileType =data.files[0].type
        var extensionflag = $.inArray(fileType,['image/jpeg',
          'image/png', 'image/gif', 'image/jpg', 'application/pdf',
          'application/msword', 'text/plain', 'text/html',
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document'])
        if (extensionflag >= 0) {
          data.submit();
        }
        else {
          alert('Invalid File Extension for: '+data.files[0].name);
          $('#load').hide()
          return false;
        }
      },
      done: function (e, data) {
        $('#load').hide()
        var id = $('#attachments_field').val();
        $('#kyu_attachment').append(data.result.attachment)
        $('#attachments_field').val(data.result.id + ',' + id);
      }
      });
  }
  // end

  // underline new post link
  function newpostlink(a1,a2)
  {
    $(a1).removeClass("menu_active")
    $(a2).addClass("menu_active")
  }
  //end

  // new entry ajaxify
  $('body').on('ajax:success', '#new_entry', function(xhr, data, status) {
    var loc = location.pathname
    if (loc != "/posts")
      location.replace("/posts#new_post")
    else
    {
      newpostlink('#home_pg',this)
      $("#new_kyu").empty().append(data.new_kyu).slideDown(2000)
      preview()
      makeflieupload()
      $('#textarea_kyu_content').markItUp(mySettings);
      history.pushState({},'','#new_post');
    }
  });

  $('body').on('ajax:beforeSend', '#formID1', function() {
    location.hash = '#';
    $(".btn_kyu_save").text("Saving...").addClass("disable-button")
  })

  $('body').on('ajax:success', '.disable-button', function() {
    return false
  });

  $('body').on('ajax:success', '#formID1', function(xhr, data, status) {
    $("#new_kyu").slideUp(800,function(){
      $(data.new_entry).insertAfter("tr:first");
      $("time.time_ago").timeago();
      $('tr:even').removeClass('odd').addClass('even');
      $('tr:odd').removeClass('even').addClass('odd');
      $(".block2").show();
      $(".new table").empty().append(data.activity)
      $("#new_kyu").empty()
      $("#sidebar").empty().append(data.sidebar)
      newpostlink('#new_entry','#home_pg')
      $(".btn_kyu_save").text("Save").removeClass("disable-button")
    });
  });


  // end

  // edit entry ajaxify
  $('body').on('ajax:success', '#edit_entry', function(xhr, data, status) {
    show_kyu = $("#main").html()
    $('#main').empty().append('<div id="edit_kyu" />')
    $("#edit_kyu").css("display", "none").append(data).show()
    preview()
    // makeflieupload()
    $('#textarea_kyu_content').markItUp(mySettings);
  });

  $('body').on('ajax:success', '#formID', function(xhr, data, status) {
    $("#edit_kyu").slideUp(100,function(){
      $("#edit_kyu").remove()
      $("#main").append(data)
      history.pushState({},'',$('#kyu_slug').val());
    });
  });
  // end

  // cancel for new and edit entry
  $('body').on('click', '#kyu_cancel', function() {
    $("#new_kyu").slideUp(800, function(){
      $("#new_kyu").empty()
      newpostlink('#new_entry','#home_pg')
    });
    $("#edit_kyu").slideUp(800, function(){
      $("#edit_kyu").remove()
      $("#main").empty().append(show_kyu)
    })
  //end
  });

  $('body').on('ajax:success', '#load_more_link', function(xhr, data, status) {
    $('.new table').append(data.activities);
    if(data.hide_link)
      $(".bottom").hide();
    else {
      current_link = this.href.split("=")
      next_page_number = parseInt(this.href.split("=")[1])+1
      $(this).attr("href", current_link[0] + "=" + next_page_number);
    }
  });
});
