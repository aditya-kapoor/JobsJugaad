$('document').ready(function(){
  $('#description').keyup(function(){
    count = $(this).val().length
    $('#description-count').text(count)
  })  
})
