module ObjectActivityHelper
  def activity_description activity
    return 'created' if activity.type == 'create'

    property = activity.property_changed
    property = 'nameserver'   if property == 'domain_host'
    property = 'registrant'   if property == 'registrant_handle'
    property = 'admin'        if property == 'admin_handle'
    property = 'billing'      if property == 'billing_handle'
    property = 'tech'         if property == 'tech_handle'
    property = 'expiry date'  if property == 'expires_at'

    if activity.old_value.nil?
      "#{property}: added entry <strong>#{activity.new_value}</strong>"
    elsif activity.old_value.blank?
      "#{property}: set value to <strong>#{activity.new_value}</strong>"
    elsif activity.new_value.nil?
      "#{property}: removed entry <strong>#{activity.old_value}</strong>"
    elsif activity.new_value.blank?
      "#{property}: set value from <strong>#{activity.old_value}</strong> to <strong>blank</strong>"
    elsif property == 'ok' and status_enabled(activity)
      'status: is now <strong>OK</strong>'
    elsif property == 'ok' and status_disabled(activity)
      'status: is no longer <strong>OK</strong>'
    elsif property == 'inactive' and status_enabled(activity)
      'status: is now <strong>inactive</strong>'
    elsif property == 'inactive' and status_disabled(activity)
      'status: is no longer <strong>inactive</strong>'
    elsif property == 'client_hold' and status_enabled(activity)
      'status: is now <strong>client hold</strong>'
    elsif property == 'client_hold' and status_disabled(activity)
      'status: is no longer <strong>client hold</strong>'
    elsif property == 'client_delete_prohibited' and status_enabled(activity)
      'status: is now <strong>client delete prohibited</strong>'
    elsif property == 'client_delete_prohibited' and status_disabled(activity)
      'status: is no longer <strong>client delete prohibited</strong>'
    elsif property == 'client_renew_prohibited' and status_enabled(activity)
      'status: is now <strong>client renew prohibited</strong>'
    elsif property == 'client_renew_prohibited' and status_disabled(activity)
      'status: is no longer <strong>client renew prohibited</strong>'
    elsif property == 'client_transfer_prohibited' and status_enabled(activity)
      'status: is now <strong>client transfer prohibited</strong>'
    elsif property == 'client_transfer_prohibited' and status_disabled(activity)
      'status: is no longer <strong>client transfer prohibited</strong>'
    elsif property == 'client_update_prohibited' and status_enabled(activity)
      'status: is now <strong>client update prohibited</strong>'
    elsif property == 'client_update_prohibited' and status_disabled(activity)
      'status: is no longer <strong>client update prohibited</strong>'
    else
      "#{property}: updated value from <strong>#{activity.old_value}</strong> to <strong>#{activity.new_value}</strong>"
    end
  end

  private

  def status_enabled activity
    activity.old_value == 'false' and activity.new_value == 'true'
  end

  def status_disabled activity
    activity.old_value == 'true' and activity.new_value == 'false'
  end
end