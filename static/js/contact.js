$(function() {
  $("#contact-collapsed").click(function() {
    $(this).hide();
    $("#contact").show();
  });

  $("#contact-title").click(function() {
    $("#contact").hide();
    $("#contact-collapsed").show();
  });

  function initContact() {
    var need_tracking = ["Parcel Status Inquiry", "Weight Dispute", "Lost Parcel Claim", "Returned Parcel"];
    var need_file = ["Weight Dispute", "Deposit"];
    if ($.inArray($("#id_subject").val(), need_tracking) > -1)
      $("#id_tracking").parent().show();
    else
      $("#id_tracking").parent().hide();

    if ($.inArray($("#id_subject").val(), need_file) > -1)
      $("#id_image").parent().show();
    else
      $("#id_image").parent().hide();
  }

  $("#id_subject").change(function() {
    initContact();
    $(".errorlist").remove();
  });

  initContact();
});
