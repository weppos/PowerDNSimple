gcm -Module PowerDNSimple

Get-SMPLDomains -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

Get-SMPLDomainRecords -domain <domain.com> -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

Add-SMPLDomainRecord -name "test" -recordType "A" -content "127.0.0.1" -domain <domain.com> -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

Update-SMPLDomainRecord -name test -content "127.0.0.1" -ttl 300 -domain <domain.com> -recordID <recordID> -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken

Remove-SMPLDomainRecord -domain <domain.com> -recordID <recordID> -emailAddress $DNSimpleEmailAddress -domainApiToken $DNSimpleToken