
$(document).ready(function()
{
  if (startInEditMode)
    $('.show-col').toggle();
  else
    $('.edit-col').toggle();
  
  $('#show-new-tenant-form').toggle();

  var oldEditButtonText = $('#allow-editing-switch').html();
  var NEW_EDIT_BUTTON_TEXT = "Finished Editing";
  $('#allow-editing-switch').click(function()
  {
    $('.edit-col').toggle();
    $('.show-col').toggle();
    if ($('#allow-editing-switch').html() == oldEditButtonText)
    {
      $('#allow-editing-switch').html(NEW_EDIT_BUTTON_TEXT);
    }
    else
    {
      $('#allow-editing-switch').html(oldEditButtonText);
    }
  });

  var newTenButtonText = $('#show-new-tenant-form-button').html();
  var ALT_TENANT_BUTTON_TEXT = "Cancel";
  $('#show-new-tenant-form-button').click(function ()
  {
    $('#show-new-tenant-form').toggle();
    if ($('#show-new-tenant-form-button').html() == newTenButtonText)
    {
      $('#show-new-tenant-form-button').html(ALT_TENANT_BUTTON_TEXT);
    }
    else
    {
      $('#show-new-tenant-form-button').html(newTenButtonText);
    }
  });

});
