action :create do
  require "fog"
  require "nokogiri"

  def name
    @name ||= new_resource.name
  end

  def value
    @value ||= new_resource.value
  end

  def type
    @type ||= new_resource.type
  end

  def ttl
    @ttl ||= new_resource.ttl
  end

  def overwrite
    @overwrite ||= new_resource.overwrite
  end

  def dns
    begin
      @dns ||= Fog::DNS.new({ :provider => "aws", :use_iam_profile => true })
    rescue ArgumentError => e
      Chef::Log.error 'Unable to connect to AWS. Verify IAM Role is set'
      return nil
    end
  end

  def zone
    @zone ||= dns.zones.detect{|z| z.domain == new_resource.domain}
    Chef::Log.error "Could not find zone #{new_resource.domain}" if @zone.nil?
    @zone
  end

  def create
    begin
      zone.records.create({ :name => name,
                            :value => value,
                            :type => type,
                            :ttl => ttl })
    rescue Excon::Errors::BadRequest => e
      Chef::Log.error Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text
    end
  end

  if zone.nil? || dns.nil?
    Chef::Log.error 'DNS registration failed: Add to Route 53 Manually!'
  else

    record = zone.records.all.select do |record|
      record.name == name
    end.first

    if record.nil?
      create
      Chef::Log.info "Record created: #{name}"
    elsif overwrite
      record.destroy
      create
      Chef::Log.info "Record modified: #{name}"
    else
      Chef::Log.info "Record exists, not modifying: #{name}"
    end
  end
end
