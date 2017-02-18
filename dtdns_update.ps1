#Enter your hostname and your account password
#Hostname must have the subdomain.domain.com format. Ex : jeremybeuchot.dtdns.net
$hostname = ".dtdns.net"
$password = ""
$doRequest = $true

#initialize Event Log if it does not exists
#if the script fail, try to run this line in an administrator powershell command
New-EventLog -LogName Application -Source "dtdns_update"

do {
    try {
        #Get a page with your current IP
        $myIP = Invoke-WebRequest "https://domains.google.com/checkip"
        Write-Host "my ip is $myIP"
        Write-EventLog  -LogName Application -Source "dtdns_update" -EntryType Information -EventID 1 -Message "my ip is $myIP"

        #Make sure we got a IP back in the response
        If ($myIP.RawContent -match "(?:[0-9]{1,3}.){3}[0-9]{1,3}")
        {
            #Build up the URL
            $url = "http://www.dtdns.com/api/autodns.cfm?id={0}&pw={1}&client=dtdnsbash&ip={2}" -f $hostname, $password, $myIP

            #Invoke the URL
            $response = Invoke-WebRequest -Uri $url
            #content display the success or error message
            Write-Host $response.Content
            $doRequest = $false
        }
        Else {
            Write-Host "IP format is wrong"
            Write-EventLog  -LogName Application -Source "dtdns_update" -EntryType Warning -EventID 1 -Message "IP format is wrong"
        }
    }
    catch {
            $ErrorMessage = $_.Exception.Message
            Write-Host "Could not update dtdns ($ErrorMessage), retrying in 10 seconds"
            Write-EventLog  -LogName Application -Source "dtdns_update" -EntryType Warning -EventID 1 -Message "Could not update dtdns ($ErrorMessage), retrying in 10 seconds"
            Start-Sleep -Seconds 10
        }
} while ($doRequest)
