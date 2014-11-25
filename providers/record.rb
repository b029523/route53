
action :create do

require "fog"
require "nokogiri"

  def create
    begin
      zone.records.create({ :name => name,
                            :value => value,
                            :type => type,
                            :ttl => ttl })
    rescue Excon::Errors::BadRequest => e
      log Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text, "error"
    end
  end

  if dns.nil? ||zone.nil?
    log 'DNS registration failed: Add to Route 53 Manually!', "error"
  else

    record = zone.records.get name

    log "Found existing Record : #{pretty_print_record(record)}" unless record.nil?

    if record.nil?
      create
      log "Record created: #{name}"
    elsif overwrite
      record.destroy
      create
      log "Record modified: #{name}"
    else
      log "Record exists, not modifying: #{name}"
    end
  end
end

action :delete do

require "fog"
require "nokogiri"

  if dns.nil? ||zone.nil?
    log 'DNS registration failed: Add to Route 53 Manually!', "error"
  else

  record = zone.records.get name

    if record.nil?
  
        log "Record not exists: #{name}", "error"
      
    elsif record.name == name && record.value.include?(value) && record.type == type
        record.destroy
        log "Record deleted: #{name}"
    else
        log "Record is not much: #{name}", "error"
    
    end
  end
end

private 

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

  def pretty_print_record(record)
    return "" if record.nil?
    "#{record.name} IN #{record.type} #{record.value.first}"
  end

  def log(message,priority="info")
    return if message.nil? || priority.nil?
    Chef::Log.send(priority, "[Route53] #{message}")
  end

  def dns
    begin
      @dns ||= Fog::DNS.new({ :provider => "aws", :use_iam_profile => true })
    rescue ArgumentError => e
      log 'Unable to connect to AWS. Verify IAM Role is set', 'error'
      return nil
    end
  end

  def zone
    @zone ||= dns.zones.detect{|z| z.domain == new_resource.domain}
    log "Could not find zone #{new_resource.domain}", "error" if @zone.nil?
    @zone
  end

  def overwrite
    @overwrite ||= new_resource.overwrite
  end
