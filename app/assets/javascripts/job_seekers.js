$('document').ready(function(){
  $('#profile-info-legend').click(function(){
    $('#profile-container').slideToggle("slow")  
  })
  $('#jobs-applied-legend').click(function(){
    $('#applied-jobs-container').slideToggle("slow")
  })

  $('div#notice').fadeOut(3000)

  $('a#upload-resume').click(function(){
    $('#upload-resume-div').toggle()
  })

  $('img#close-div-img').click(function(){
    $('div#upload-resume-div').hide()
  })

  $('a#upload-photo').click(function(){
    $('#upload-photo-div').toggle()
  })

  $('img#close-photo-div').click(function(){
    $('div#upload-photo-div').hide()
  })

  validate = (function(){
    alert("Hello World")
  })

})