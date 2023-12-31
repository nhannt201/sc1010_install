Param(
    $solrLocation="D:\Solr\solr-8.4.0",
    $solrServiceName="solr-8.4.0"
)
# Uninstall Service
Write-Host "Checking if Solr service is installed"
$isSolrServiceInstalled = Get-Service | Where-Object {$_.Name -like "*$solrServiceName*"}
if ($null -ne $isSolrServiceInstalled) 
{
    Write-Host "Removing Solr service $solrServiceName" -ForegroundColor Cyan

    # Stop the service 
    sc.exe stop $solrServiceName

    sc.exe delete $solrServiceName 
    Start-Sleep 2
    $isSolrServiceInstalled = sc.exe query $solrServiceName
    if ( $isSolrServiceInstalled[0].Contains("1060") )
    {
        Write-Host "Removal of Solr service completed sucessfully" -ForegroundColor Green
    }
    else 
    { 
        Write-Host "Something went wrong removing Solr service named $solrServiceName" -ForegroundColor Red
        exit 1
    }

}
else 
{ 
    Write-Host "Solr service already removed, good" -ForegroundColor Green
}


# Remove folder
if ( Test-Path $solrLocation )
{
    Remove-Item -Recurse $solrLocation
    if ( -Not ( Test-Path $solrLocation ))
    {
        Write-Host "Correctly removed Solr directory at $solrLocation" -ForegroundColor Green
    }
    else 
    { 
        Write-Host "Something went wrong trying to remove the solr directory" -ForegroundColor Red
        exit 1
    }
}
else { Write-Host "Solr location $solrLocation already removed, good" -ForegroundColor Green }

Write-Host "Completed uninstallation of Solr" -ForegroundColor Green