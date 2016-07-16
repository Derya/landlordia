
$(document).ready(function()
{

  // TODO: MOVE THIS DEFAULTING PROPERTY TO CSS, also the first line should be for edit and not show
  $('.edit-col').toggle();
  $('#show-new-tenant-form').toggle();

  $('#allow-editing-switch').click(function()
  {
    $('.edit-col').toggle();
    $('.show-col').toggle();
  });

  var newTenButtonText = $('#show-new-tenant-form-button').html();
  var ALTTENBUTTONTEXT = "Cancel";
  $('#show-new-tenant-form-button').click(function ()
  {
    $('#show-new-tenant-form').toggle();
    if ($('#show-new-tenant-form-button').html() == newTenButtonText)
    {
      $('#show-new-tenant-form-button').html(ALTTENBUTTONTEXT);
    }
    else
    {
      $('#show-new-tenant-form-button').html(newTenButtonText);
    }
  });

});
