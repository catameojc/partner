class ObjectActivity
  include Api::Model

  self.resource = 'activities'

  attr_accessor :id, :type, :partner, :activity_at, :object,
                :property_changed, :old_value, :new_value,
                :losing_partner

  def object= object
    @object = AppObject.new object
  end

  def partner= partner
    @partner = Partner.new partner
  end
end
