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
#endregion

#region Domain Records
function Get-SMPLDomainRecords
{
    param(
        [Parameter(ValueFromPipeline = $true)]
        $domain,
        $emailAddress,
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

function Update-SMPLDomainRecord
{
    param(
        $name,
        $content,
        $ttl,
        $prio,
        [Parameter(ValueFromPipeline = $true)]
        $domain,
        [Parameter(ValueFromPipeline = $true)]
        $recordID,
        $emailAddress,
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
#endregion

Export-ModuleMember -Function Update-SMPLDomainRecord, Get-SMPLDomainRecords