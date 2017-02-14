#Enter your hostname and your account $password
#Hostname must have the subdomain.domain.com. Ex : jeremybeuchot.dtdns.net
$hostname = ""
$password = ""

#Get a page with your current IP
$myIP = Invoke-WebRequest "https://domains.google.com/checkip"
Write-Host "my ip is " $myIP

#Make sure we got a IP back in the response
If ($myIP.RawContent -match "(?:[0-9]{1,3}.){3}[0-9]{1,3}")
{
    #Build up the URL
    $url = "http://www.dtdns.com/api/autodns.cfm?id={0}&pw={1}&client=dtdnsbash&ip={2}" -f $hostname, $password, $myIP

    #Invoke the URL
    $response = Invoke-WebRequest -Uri $url
    #content display the success or error message
    Write-Host $response.Content
}
Else {
    Write-Host "IP format is wrong"
}