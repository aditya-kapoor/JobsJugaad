$('document').ready(function(){

  $('#profile-info-legend').click(function(){
    $('#profile-container').slideToggle("slow")
  })
  
  $('#jobs-applied-legend').click(function(){
    $('#applied-jobs-container').slideToggle("slow")
  })

  $('a#upload-resume').click(function(){
    // alert("HELLO resume")
    $('div#upload-resume-div').show()
  })

  $('img#close-div-img').click(function(){
    $('div#upload-resume-div').hide()
  })

  $('a#upload-photo').click(function(){
    // alert("HELLO photo")
    $('div#upload-photo-div').show()
  })

  $('img#close-photo-div').click(function(){
    $('div#upload-photo-div').hide()
  })

  validate = (function(){
    alert("Hello World")
  })

})