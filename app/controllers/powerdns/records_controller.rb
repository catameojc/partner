class Powerdns::RecordsController < SecureController
  before_action :load_domain, only: [:new, :edit]

  def new
    @pdns_record = Powerdns::Record.new
  end

  def create
    pdns_record = Powerdns::Record.new pdns_params

    domain_id = params[:powerdns_record][:powerdns_domain_id]

    if pdns_record.save token: auth_token
      redirect_to domain_url(domain_id), notice: 'DNS Record added!'
    else
      redirect_to domain_url(domain_id), notice: 'Not Saved!'
    end
  end

  def edit
    @pdns_record = Powerdns::Record.find params[:id], token: auth_token
  end

  def update
    pdns_record = Powerdns::Record.find params[:id], token: auth_token
    domain_id = params[:domain_id]

    update_record pdns_record, domain_id
  end

  def destroy
    domain = params[:domain_id]
    Powerdns::Record.destroy params[:id], token: auth_token
    redirect_to domain_url(domain)
  end

  private
  def pdns_params
    params.require(:powerdns_record).permit :name, :type, :prio, :content, :powerdns_domain_id, :end_date,
                                            :ttl, :change_date, preferences: [:weight, :port, :srv_content]
  end

  def update_record pdns_record, domain_id
    pdns_record.name    = params[:powerdns_record][:name]
    pdns_record.type    = params[:powerdns_record][:type]
    pdns_record.prio    = params[:powerdns_record][:prio]
    pdns_record.content = params[:powerdns_record][:content]
    pdns_record.preferences[:weight]       = params[:powerdns_record][:preferences][:weight]
    pdns_record.preferences[:port]         = params[:powerdns_record][:preferences][:port]
    pdns_record.preferences[:srv_content]  = params[:powerdns_record][:preferences][:srv_content]

    if pdns_record.update token: auth_token
      redirect_to domain_url(domain_id), notice: 'DNS Record updated!'
    else
      redirect_to domain_url(domain_id), notice: 'Not Updated!'
    end
  end

  def load_domain
    domain = Domain.find(params[:domain_id], token: auth_token)
    @domain_id = domain.id
    @domain_name = domain.name
    @domain_expires_at = domain.expires_at
  end
end
