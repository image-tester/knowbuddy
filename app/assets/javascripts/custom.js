$(document).ready(function(){
    $('#textarea_kyu_content').markItUp(mySettings);
    $("#formID").validationEngine();

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
          url: '/kyu_entries/parse_content',
          data: { divcontent: content},
          dataType: 'json',
          success: function(data){
            $("#default_preview").html(data);
            jQuery.facebox({ div: '#default_preview' });
         },
         error: function(error) { alert(error)}
      });}
    });

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

    $("#new_comment").live("ajax:success", function(xhr, data, status) {
      $("#latest_comment").prepend(data).fadeOut(200).fadeIn(2000)
      $('#comment_comment').val('')
    });
    //end
});

