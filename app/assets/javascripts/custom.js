$(document).ready(function(){
    $("#formID").validationEngine();
    var mylist = $('#namelist');
    var listitems = mylist.children('li').get();
    listitems.sort(function(a, b) {
      return $(a).text().toUpperCase().localeCompare($(b).text().toUpperCase());
    })
    $.each(listitems, function(idx, itm) { mylist.append(itm); });
});

