$(function() {
  $("#job_application_interview_on").datepicker({ dateFormat : "dd-mm-yy", minDate: 0, numberOfMonths: 2 });
})

$('document').ready(function(){
  $('#description').keyup(function(){
    count = $(this).val().length
    $('#description-count').text(count)
  })
  
  $('#authorize-link').click(function(event){
    event.preventDefault()
    // alert($(this).attr('href'))
    var url = $(this).attr('href')
    myWindow = window.open( url, "height=450,width=400,overflow=hidden,scroll=no,status=no");
  })
  
})
