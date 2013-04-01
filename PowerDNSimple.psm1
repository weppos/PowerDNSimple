<#
    
    Author: Ian Philpot (http://adminian.com)
    File: DNSimple.psm1
    Description: Module for working with DNSimple API.

#>

#region Helper Functions
function GetRequest
{
    param(
        $url,
        $emailAddress,
        $domainApiToken
    )

    [System.Net.HttpWebRequest]$request = [System.Net.WebRequest]::Create($url)
    $request.Accept = "application/json"
    $request.Method = "GET"
    $dnsimpleToken = $emailAddress + ":" + $domainApiToken
    $request.Headers.add("X-DNSimple-Token", $dnsimpleToken)

    $response = $request.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = New-object System.IO.StreamReader($stream)
    $json = ConvertFrom-Json ($reader.ReadToEnd())
    $reader.Dispose()

    return $json
}

function PostRequest
{
    param(
        $url,
        $jsonData,
        $emailAddress,
        $domainApiToken
    )

    [System.Net.HttpWebRequest]$request = [System.Net.WebRequest]::Create($url)
    $request.Accept = "application/json"
    $request.ContentType = "application/json" 
    $request.Method = "POST"
    $dnsimpleToken = $emailAddress + ":" + $domainApiToken
    $request.Headers.add("X-DNSimple-Token", $dnsimpleToken)
    $request.ContentLength = $jsonData.ToString().length

    [System.IO.StreamWriter]$writer = $request.GetRequestStream()
    $writer.Write($jsonData)
    $writer.Close()

    $response = $request.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = New-object System.IO.StreamReader($stream)
    $json = ConvertFrom-Json ($reader.ReadToEnd())
    $reader.Dispose()

    return $json
}

function PutRequest
{
    param(
        $url,
        $jsonData,
        $emailAddress,
        $domainApiToken
    )

    [System.Net.HttpWebRequest]$request = [System.Net.WebRequest]::Create($url)
    $request.Accept = "application/json"
    $request.ContentType = "application/json" 
    $request.Method = "PUT"
    $dnsimpleToken = $emailAddress + ":" + $domainApiToken
    $request.Headers.add("X-DNSimple-Token", $dnsimpleToken)
    $request.ContentLength = $jsonData.ToString().length

    [System.IO.StreamWriter]$writer = $request.GetRequestStream()
    $writer.Write($jsonData)
    $writer.Close()

    $response = $request.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = New-object System.IO.StreamReader($stream)
    $json = ConvertFrom-Json ($reader.ReadToEnd())
    $reader.Dispose()

    return $json
}

function DeleteRequest
{
    param(
        $url,
        $emailAddress,
        $domainApiToken
    )

    [System.Net.HttpWebRequest]$request = [System.Net.WebRequest]::Create($url)
    $request.Accept = "application/json"
    $request.ContentType = "application/json" 
    $request.Method = "DELETE"
    $dnsimpleToken = $emailAddress + ":" + $domainApiToken
    $request.Headers.add("X-DNSimple-Token", $dnsimpleToken)

    $response = $request.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = New-object System.IO.StreamReader($stream)
    $json = ConvertFrom-Json ($reader.ReadToEnd())
    $reader.Dispose()

    return $json
}
#endregion

#region Domains
function Get-SMPLDomains
{
    param(
        [Parameter(Mandatory = $true)]
        $emailAddress,
        [Parameter(Mandatory = $true)]
        $domainApiToken,
        [Switch]
        $PassThru
    )

    $url = "https://dnsimple.com/domains"

    $response = GetRequest -url $url -emailAddress $emailAddress -domainApiToken $domainApiToken

    if ($passThru)
    {
        return $response
    }
    else
    {
        $response.domain
    }
}
#endregion

#region Domain Records
function Get-SMPLDomainRecords
{
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $domain,
        [Parameter(Mandatory = $true)]
        $emailAddress,
        [Parameter(Mandatory = $true)]
        $domainApiToken,
        [Switch]
        $PassThru
    )

    $url = "https://dnsimple.com/domains/$domain/records"

    $response = GetRequest -url $url -emailAddress $emailAddress -domainApiToken $domainApiToken

    if ($passThru)
    {
        return $response
    }
    else
    {
        $response.record
    }
}

function Add-SMPLDomainRecord
{
    param(
        [Parameter(Mandatory = $true)]
        $name,
        [Parameter(Mandatory = $true)]
        $recordType,
        [Parameter(Mandatory = $true)]
        $content,
        $ttl,
        $prio,
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $domain,
        [Parameter(Mandatory = $true)]
        $emailAddress,
        [Parameter(Mandatory = $true)]
        $domainApiToken,
        [Switch]
        $passThru
    )

    $url = "https://dnsimple.com/domains/$domain/records"
    $items = @{"record"=@{}}

    if ($name)
    {
        $items.record.name = $name
    }

    if ($recordType)
    {
        $items.record.record_type = $recordType
    }

    if ($content)
    {
        $items.record.content = $content
    }

    if ($ttl)
    {
        $items.record.ttl = $ttl
    }

    if ($prio)
    {
        $items.record.prio = $prio
    }

    $jsonData = $items | ConvertTo-Json

    $response = PostRequest -url $url -jsonData $jsonData -emailAddress $emailAddress -domainApiToken $domainApiToken

    if ($passThru)
    {
        return $response
    }
    else
    {
        $response.record
    }
}

function Update-SMPLDomainRecord
{
    param(
        [Parameter(Mandatory = $true)]
        $name,
        [Parameter(Mandatory = $true)]
        $content,
        $ttl,
        $prio,
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $domain,
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $recordID,
        [Parameter(Mandatory = $true)]
        $emailAddress,
        [Parameter(Mandatory = $true)]
        $domainApiToken,
        [Switch]
        $passThru
    )

    $url = "https://dnsimple.com/domains/$domain/records/$recordID"
    $items = @{"record"=@{}}

    if ($name)
    {
        $items.record.name = $name
    }

    if ($content)
    {
        $items.record.content = $content
    }

    if ($ttl)
    {
        $items.record.ttl = $ttl
    }

    if ($prio)
    {
        $items.record.prio = $prio
    }

    $jsonData = $items | ConvertTo-Json

    $response = PutRequest -url $url -jsonData $jsonData -emailAddress $emailAddress -domainApiToken $domainApiToken

    if ($passThru)
    {
        return $response
    }
    else
    {
        $response.record
    }
}

function Remove-SMPLDomainRecord
{
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $domain,
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $recordID,
        [Parameter(Mandatory = $true)]
        $emailAddress,
        [Parameter(Mandatory = $true)]
        $domainApiToken,
        [Switch]
        $passThru
    )

    $a = Read-Host "Are you sure you want to delete this record? (Y/N)"
    $url = "https://dnsimple.com/domains/$domain/records/$recordID"

    if ($a -eq "Y")
    {
        $response = DeleteRequest -url $url -emailAddress $emailAddress -domainApiToken $domainApiToken
        if ($passThru)
        {
            return $response
        }
        else
        {
            $response.record
        }
    }
    else
    {
        Write-Host "Operation aborted" -ForegroundColor Yellow
    }
}
#endregion

Export-ModuleMember -Function Get-SMPLDomains, Get-SMPLDomainRecords,  Add-SMPLDomainRecord, Update-SMPLDomainRecord, Remove-SMPLDomainRecord