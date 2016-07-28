class DomainHost
  include Api::Model

  attr_accessor :id, :domain, :name, :ip_list, :created_at, :updated_at

  validates :domain,  presence: true
  validates :name,    presence: true

  def as_json options = nil
    {
      name: name,
      ip_list: ip_list
    }
  end

  def self.url domain_id, id: nil
    super resource: "domains/#{domain_id}/hosts", id: id
  end

  def self.destroy domain_id, id, token:
    response = delete url(domain_id, id: id), {}, token: token

    new response
  end

  def save token:
    return false unless valid?

    response = self.class.post self.class.url(self.domain), self.as_json, token: token

    !response.nil?
  rescue Api::Model::UnprocessableEntity
    self.errors.add :name, 'already in use'

    false
  end
end
