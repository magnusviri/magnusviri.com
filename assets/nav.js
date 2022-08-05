$('.sub-menu > a').click(function() {
  $(this).toggleClass('active').next('ul').slideToggle();
  $(this).parent('li').siblings().children('ul').slideUp();
  $(this).parent('li').siblings().children('.active').removeClass('active');
  $(this).children('i').toggleClass('fa-angle-right fa-angle-down')
  return false;
});
$('#hamburger').click(function(){
  $(this).siblings('ul').slideToggle('active');
  $(this).toggleClass('fa-bars fa-times')
});
