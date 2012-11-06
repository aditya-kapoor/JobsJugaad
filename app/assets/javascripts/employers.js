$(function() {
  $("#job_application_interview_on").datepicker({ dateFormat : "dd-mm-yy", minDate: 0, numberOfMonths: 2 });
})

$('document').ready(function(){
  $('#description').keyup(function(){
    count = $(this).val().length
    $('#description-count').text(count)
  })  
})
