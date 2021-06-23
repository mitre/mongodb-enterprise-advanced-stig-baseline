  control "V-81917" do
  title "MongoDB must only accept end entity certificates issued by DoD PKI or
  DoD-approved PKI Certification Authorities (CAs) for the establishment of all
  encrypted sessions."
  desc "Only DoD-approved external PKIs have been evaluated to ensure that
  they have security controls and identity vetting procedures in place which are
  sufficient for DoD systems to rely on the identity asserted in the certificate.
  PKIs lacking sufficient security controls and identity vetting procedures risk
  being compromised and issuing certificates that enable adversaries to
  impersonate legitimate users.

  The authoritative list of DoD-approved PKIs is published at
  http://iase.disa.mil/pki-pke/interoperability.

  This requirement focuses on communications protection for MongoDB session
  rather than for the network packet.
  "

  desc "check", "To run MongoDB in SSL mode, you have to obtain a valid
  certificate singed by a single certificate authority.

  Before starting the MongoDB database in SSL mode, verify that certificate used
  is issued by a valid DoD certificate authority (openssl x509 -in
  <path_to_certificate_pem_file> -text | grep -i \"issuer\").

  If there is any issuer present in the certificate that is not a DoD approved
  certificate authority, this is a finding."
  desc "fix", "Remove any certificate that was not issued by an approved DoD
  certificate authority. Contact the organization's certificate issuer and
  request a new certificate that is issued by a valid DoD certificate
  authorities."
  
  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "SRG-APP-000427-DB-000385"
  tag "gid": "V-81917"
  tag "rid": "SV-96631r1_rule"
  tag "stig_id": "MD3X-00-000730"
  tag "fix_id": "F-88767r1_fix"
  tag "cci": ["CCI-002470"]
  tag "nist": ["SC-23 (5)"]
  tag "documentable": false
  tag "severity_override_guidance": false

  # Process flag takes precedence over the conf file
  x509_conf = yaml(input('mongod_conf'))['net', 'tls', 'certificateKeyFile']
  x509_process_flag = processes('mongod').commands.join.gsub('--tlsCertificateKeyFile', '').strip

  x509_cert_file = input('x509_cert_file') unless input('x509_cert_file').nil?
  x509_cert_file = x509_conf unless x509_conf.nil?
  x509_cert_file = x509_process_flag unless x509_process_flag.nil?
  

  if file(x509_cert_file).exist? 
    describe x509_certificate(x509_cert_file) do
      its('issuer_dn') { should eq input('authorized_certificate_authority') }
    end
  else
    describe 'x509 file not found, manual review required' do
      skip 'x509 file not found, manual review required'
    end
  end
end
