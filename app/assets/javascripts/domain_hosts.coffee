$ ->
  $(".btn-add-domain-host-ipv4").click ->
    array = $('.domain-host-ipv4-field').length
    row =  "<label class='ipv4_" + array + "'></label>
            <div class='ipv4_" + array + "'>
              <div class='form-group'>
                <input type='text' name='ipv4[" + array + "]' id='ipv4_" + array + "' class='form-control domain-host-ipv4-field' placeholder='Enter IP Address'>
              </div>
              <a class='btn btn-default btn-sm btn-remove-domain-host-ipv4'>
                <i class='fa fa-close'></i>
                <span class='sr-only'>Delete</span>
              </a>
            </div>"
    $(".moreIPV4").append(row)

  $(".btn-add-domain-host-ipv6").click ->
    array = $('.domain-host-ipv6-field').length
    row =  "<label class='ipv6_" + array + "'></label>
            <div class='ipv6_" + array + "'>
              <div class='form-group'>
                <input type='text' name='ipv6[" + array + "]' id='ipv6_" + array + "' class='form-control domain-host-ipv6-field' placeholder='Enter IP Address'>
              </div>
              <a class='btn btn-default btn-sm btn-remove-domain-host-ipv6'>
                <i class='fa fa-close'></i>
                <span class='sr-only'>Delete</span>
              </a>
            </div>"
    $(".moreIPV6").append(row)

  $(".moreIPV6").on "click", ".btn-remove-domain-host-ipv6", ->
    thisParentClass = $(this).parent().prop('className')
    $('.' + thisParentClass).remove()
    return

  $(".moreIPV4").on "click", ".btn-remove-domain-host-ipv4", ->
    thisParentClass = $(this).parent().prop('className')
    $('.' + thisParentClass).remove()
    return

  $("#domain_host_name").keyup ->
    domainName = $(this).data("domain")
    glue_record_requirement = "." + domainName
    if $(this).val().indexOf(glue_record_requirement) >= 0
      $(".nameserver-ipv4, .nameserver-ipv6, .moreIPV4, .moreIPV6").show()
    else
      $(".nameserver-ipv4, .nameserver-ipv6, .moreIPV4, .moreIPV6").find('input:text').val('');
      $(".nameserver-ipv4, .nameserver-ipv6, .moreIPV4, .moreIPV6").hide()
    return

  $("#domain_host_name").trigger("keyup")