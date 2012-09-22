$('document').ready(function(){
  $('#profile-info-legend').click(function(){
    $('#profile-container').slideToggle("slow")  
  })
  $('#jobs-applied-legend').click(function(){
    $('#applied-jobs-container').slideToggle("slow")
  })

  $('div#notice').fadeOut(3000)

})