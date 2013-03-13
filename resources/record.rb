actions :create

attribute :name,      :kind_of => String,  :regex => /\.\w{2,}\.$/
attribute :value,     :kind_of => String,  :regex => /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|\.\w{2,}\.)$/
attribute :type,      :kind_of => String,  :equal_to => %w[SOA A TXT NS CNAME MX PTR SRV SPF AAAA]
attribute :ttl,       :kind_of => Integer, :default  => 300
attribute :domain,    :kind_of => String,  :regex => /\.\w{2,}\.$/
attribute :overwrite, :kind_of => [TrueClass, FalseClass], :default => false

def with_trailing_dot(fqdn)
  if fqdn =~ /.*\.$/
    fqdn
  else
    "#{fqdn}."
  end
end
