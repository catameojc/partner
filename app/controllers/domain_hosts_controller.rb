class DomainHostsController < SecureController
  def index
    @domain_id = params[:domain_id]
    domain = Domain.find @domain_id, token: auth_token
    @domain_name = domain.name
    @domain_host = DomainHost.new
  end

  def add_default_nameservers
    domain = Domain.find params[:id], token: auth_token
    output = true

    if params[:dotph_default]
      nameserver_datas = Nameserver.all token: auth_token
    else
      nameserver_datas = current_user.partner.default_nameservers
    end

    nameservers = nameserver_datas.map{|ns| ns.name}
    domain_hosts = domain.hosts.map{|host| host.name}

    domain.hosts.each do |host|
      unless nameservers.include? host.name
        DomainHost.destroy domain.name, host.name, token: auth_token
      end
    end

    nameservers.each do |nameserver|
      unless domain_hosts.include? nameserver
        @domain_host = DomainHost.new
        @domain_host.domain = domain.name
        @domain_host.name = nameserver

        if @domain_host.save token: auth_token
        else
          output = false
        end
      end
    end

    if output
      redirect_to domain_url(domain.id), notice: 'Nameserver list updated!'
    else
      @domain_id = domain.id
      render :index
    end
  end

  def create
    list = {"ipv4": params[:ipv4], "ipv6": params[:ipv6]}.to_json

    domain = Domain.find params[:domain_id], token: auth_token

    @domain_host = DomainHost.new create_params.merge(domain: domain.name)
    @domain_host.ip_list = list

    if @domain_host.save token: auth_token
      redirect_to domain_url(domain.id), notice: 'Nameserver added!'
    else
      @domain_id = domain.id

      render :index
    end
  end

  def edit
    @domain = Domain.find params[:domain_id], token: auth_token
    @domain_host = DomainHost.find params[:domain_id], params[:id], token: auth_token
    if @domain_host.ip_list
      ip_list = @domain_host.ip_list
      @ip_list = JSON.parse ip_list
    end
  end

  def update
    list = {"ipv4": params[:ipv4], "ipv6": params[:ipv6]}.to_json
    domain_id = params[:domain_id]
    domain_host = DomainHost.find domain_id, params[:id], token: auth_token
    domain_host.name = create_params[:name]
    domain_host.ip_list = list

    if domain_host.update domain_id, token: auth_token
      redirect_to domain_url(domain_id), notice: 'Nameserver updated!'
    else
      redirect_to domain_url(domain_id), notice: 'Not Updated!'
    end
  end

  def destroy
    domain  = params[:domain_id]
    host    = DomainHost.destroy domain, params[:id], token: auth_token

    redirect_to domain_url(domain), notice: 'Nameserver deleted!'
  end

  private

  def create_params
    params.require(:domain_host).permit :name
  end
end