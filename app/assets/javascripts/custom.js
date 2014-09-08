$(document).ready(function(){

  var strDefaultValForPostTextarea = "h1. This is Textile markup. Give it a try! \n \n A *simple* paragraph with a line break, some _emphasis_ and a \"link\":http://redcloth.org \n\n * an item \n * and another \n\n # one \n # two";
  $('#textarea_post_content').markItUp(mySettings);
  $("#formID1").validationEngine();

  $('#new_post').keypress(function(){
    $('#save_as_draft').removeAttr('disabled');
  });

  function save_as_draft() {
    $('#save_as_draft').click(function(){
      $('#save_as_draft').hide()
      $('#loading').show()
      save_draft()
    });
  }

  function preview() {
    $("#previewlink").click(function(e) {
      $(this).facebox();
      var content = $(".text_area").val();
      if(content == strDefaultValForPostTextarea)
      { content = "";
        $("#textarea_post_content").validationEngine('validate');
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
    $('.time_ago').timeago()
  });
  //end

  //File Preview icon display
  //start
  function makeflieupload() {
    $('#fileupload').fileupload({
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
        $('#post_attachment').append(data.result.attachment)
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
      $("#new_post").empty().append(data.new_post).slideDown(2000)
      preview()
      makeflieupload()
      $('#save_as_draft').attr('disabled','disabled');
      $('#loading').hide();
      $('#textarea_post_content').markItUp(mySettings);
      history.pushState({},'','#new_post');
      save_as_draft()
      autosave()
    }
  });

  $('body').on('ajax:beforeSend', '#formID1', function() {
    location.hash = '#';
    $(".btn_post_save").text("Saving...").addClass("disable-button")
  })

  $('body').on('ajax:success', '.disable-button', function() {
    return false
  });

  $('body').on('ajax:success', '#formID1', function(xhr, data, status) {
    $("#new_post").slideUp(800,function(){
      $(data.new_entry).insertAfter("tr:first");
      $("time.time_ago").timeago();
      $('tr:even').removeClass('odd').addClass('even');
      $('tr:odd').removeClass('even').addClass('odd');
      $(".block2").show();
      $(".new table").html(data.activities)
      $("#new_post").empty()
      $("#sidebar").empty().append(data.sidebar)
      newpostlink('#new_entry','#home_pg')
      $(".btn_post_save").text("Save").removeClass("disable-button")
    });
  });
  // end

  // edit entry ajaxify
  $('body').on('ajax:success', '#edit_entry', function(xhr, data, status) {
    show_post = $("#main").html()
    $('#main').empty().append('<div id="edit_post" />')
    $("#edit_post").css("display", "none").append(data).show()
    preview()
    $('#save_as_draft').show()
    $('#loading').hide()
    makeflieupload()
    $('#textarea_post_content').markItUp(mySettings);
    save_as_draft()
    autosave()
  });

  $('body').on('ajax:success', '#formID', function(xhr, data, status) {
    $("#edit_post").slideUp(100,function(){
      $("#edit_post").remove()
      $("#main").append(data)
      $('.time_ago').timeago();
      history.pushState({},'',$('#post_slug').val());
    });
  });
  // end

  // cancel for new and edit entry
  $('body').on('click', '#post_cancel', function() {
    $("#new_post").slideUp(800, function(){
      $("#new_post").empty()
      newpostlink('#new_entry','#home_pg')
    });
    $("#edit_post").slideUp(800, function(){
      $("#edit_post").remove()
      $("#main").empty().append(show_post)
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

  function autosave() {
    if($("#new_post").length > 0 || $("#edit_post").length > 0 ) {
      setInterval( function(){ save_draft(); }, 30000 );
    }
  }

  function save_draft() {
    var post = ($("#new_post").length > 0) ? $("#new_post") : $("#edit_post")
    post_subject = post.find('#post_subject').val();
    post_content = post.find('#textarea_post_content').val();
    if ( post_content == strDefaultValForPostTextarea ){
      post_content = "";
    }
    user = post.find('#post_user_id').val();
    post_id = post.find('#post_id').val();
    var attachment_values = ""
    if ( post.find('#attach-content').length > 0) {
      attachment_values = attachments_field.value
    }
    var tags = post_tag_list.value
    if( post_subject.length > 0 || post_content.length >0 || post.find('#attach-content').length > 0) {
      $.ajax({
        type: "POST",
        dataType: "JSON",
        url: "/posts/draft",
        data: { post: { id: post_id,
          subject: post_subject,
          content: post_content,
          user_id: user,
          tag_list: tags,
          is_draft: true },
          attachments_field: attachment_values
        },
        success: function(data){
          post.find('#post_id').val(data.new_post);
          $('.draft').html('Saved');
          $('#save_as_draft').show();
          $('#loading').hide();
        }
      });
    }
  }


});
