PowerDNSimple
=============

PowerShell module for working with DNSimple API.

Useage
======

*Set Domain API Token
**$DNSimpleToken = "<DNSimple API token goes here>"

*Set Email address
**$DNSimpleEmailAddress = "<DNSimple email address goes here>"

*View the functions in this module
**gcm -Module PowerDNSimple

*List DNSimple domains
**Get-SMPLDomains -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

*List DNSimple domain records
**Get-SMPLDomainRecords -domain domain.com -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

*Create a new A record for domain
**Add-SMPLDomainRecord -name "test" -recordType "A" -content "127.0.0.1" -domain domain.com -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

*Update domain record (recordID is ID of domain record)
**Update-SMPLDomainRecord -name test -content "127.0.0.1" -ttl 300 -domain domain.com -recordID 111111 -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

*Delete domain record (recordID is ID of domain record)
**Remove-SMPLDomainRecord -domain domain.com -recordID 111111 -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken
