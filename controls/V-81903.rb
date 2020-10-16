control "V-81903" do
  title "MongoDB must utilize centralized management of the content captured in
  audit records generated by all components of MongoDB."
  desc  "Without the ability to centrally manage the content captured in the
  audit records, identification, troubleshooting, and correlation of suspicious
  behavior would be difficult and could lead to a delayed or incomplete analysis
  of an ongoing attack.

      The content captured in audit records must be managed from a central
  location (necessitating automation). Centralized management of audit records
  and logs provides for efficiency in maintenance and management of records, as
  well as the backup and archiving of those records.

      MongoDB may write audit records to database tables, to files in the file
  system, to other kinds of local repository, or directly to a centralized log
  management system. Whatever the method used, it must be compatible with
  off-loading the records to the centralized system.
  "
  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "SRG-APP-000356-DB-000314"
  tag "gid": "V-81903"
  tag "rid": "SV-96617r1_rule"
  tag "stig_id": "MD3X-00-000600"
  tag "fix_id": "F-88753r1_fix"
  tag "cci": ["CCI-001844"]
  tag "nist": ["AU-3 (2)", "Rev_4"]
  tag "documentable": false
  tag "severity_override_guidance": false

  desc "check", "MongoDB can be configured to write audit events to the syslog
  in Linux, but this is not available in Windows. Audit events can also be
  written to a file in either JSON on BSON format. Through the use of third-party
  tools or via syslog directly, audit records can be pushed to a centralized log
  management system.

  If a centralized tool for log management is not installed and configured to
  collect audit logs or syslogs, this is a finding."
  desc "fix", "Install a centralized syslog collecting tool and configured it as
  instructed in its documentation.

  To enable auditing and print audit events to the syslog in JSON format, specify
  the syslog for the --auditDestination setting:
  mongod --dbpath data/db --auditDestination syslog

  Alternatively, these options can also be specified in the configuration file:
  storage:
  dbPath: data/db
  auditLog:
  destination: syslog"
  describe yaml(input('mongod_conf')) do
    its(%w{storage dbPath}) { should cmp '/data/db' }
  end
  describe yaml(input('mongod_conf')) do
    its(%w{auditLog destination}) { should cmp 'syslog' }
  end
end
