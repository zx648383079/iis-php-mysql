function down ($url, $name = '') {
    if ($name -eq '') {
        $name = $regex.match($url).value
    }
    $name
    $client.DownloadFile($url, $dowmDir + $name);
}

function runExe($file, $args = '') {
    Start-Process -FilePath $file -ArgumentList $args -NoNewWindow
}

function installIIS () {
    
}

function unzip ($file, $dir) {
    #确保目标文件夹必须存在
    if(!(Test-Path $dir)) {
        mkdir $dir
    }
    $shellApp = New-Object -ComObject Shell.Application
    $files = $shellApp.NameSpace($file).Items()
    $shellApp.NameSpace($dir).CopyHere($files)
}

function installPHP ($file, $dir) {
    unzip $file $dir;
    Copy-Item $dir + '\php.ini-production' -Destination $dir + '\php.ini'

}

function installMYSQL ($file, $dir) {
    unzip $file $dir;
    $ini = Get-Content $currDir + '\my.ini';
    $ini.Replace('{path}', $dir) | Out-File $dir + '\my.ini'
    runExe $dir + '\bin\mysqld.exe' '--initialize-insecure'
    runExe $dir + '\bin\mysqld.exe' '-install'
    # net start mysql
    # runExe $dir + '\bin\mysql_upgrade.exe' '-u root -p --force'
}

function setIIS () {
    
}

function downFiles() {
    down 'https://notepad-plus-plus.org/repository/7.x/7.5.6/npp.7.5.6.Installer.exe'
    down 'http://curl.haxx.se/ca/cacert.pem'
    down 'https://www.heidisql.com/downloads/releases/HeidiSQL_9.5_Portable.zip' 'HeidiSQL.zip'
    down 'https://windows.php.net/downloads/releases/php-5.6.36-nts-Win32-VC11-x64.zip' 'php.zip'
    down 'https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.11-winx64.zip' 'mysql.zip'
    down 'https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe' 'vc14.exe'
    down 'https://download.microsoft.com/download/9/C/D/9CD480DC-0301-41B0-AAAB-FE9AC1F60237/VSU4/vcredist_x64.exe' 'vc11.exe'
    #down 'https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe'
    #down 'https://download.microsoft.com/download/9/C/D/9CD480DC-0301-41B0-AAAB-FE9AC1F60237/VSU4/vcredist_x86.exe'
    down 'https://download.microsoft.com/download/F/3/5/F3500770-8A08-488E-94B6-17A1E1DD526F/vcredist_x64.exe' 'vc12.exe'
    
    down 'https://files.phpmyadmin.net/phpMyAdmin/4.7.9/phpMyAdmin-4.7.9-all-languages.zip'
    down 'https://webpihandler.azurewebsites.net/web/handlers/webpi.ashx/getinstaller/urlrewrite2.appids' 'urlrewrite2.exe'
}

function installFiles ($dir) {
    if(!(Test-Path $dir)) {
        mkdir $dir
    }
    unzip $dowmDir + '\HeidiSQL.zip' $dir + '\HeidiSQL'
    installPHP $dowmDir + '\php.zip' $dir + '\php'
    installMYSQL $dowmDir + '\mysql.zip' $dir + '\mysql'
    Copy-Item $dowmDir + '\cacert.pem' $dir
}

$regex = [regex]"[^/]+$";
$client = new-object System.Net.WebClient;
# 防止ssl报错
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$currDir = Split-Path -Parent $MyInvocation.MyCommand.Definition;
$dowmDir = $currDir + '\';

downFiles 
installFiles 'C:\Program Files\'