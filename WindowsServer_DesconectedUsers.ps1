# Tempo em minutos que sera o máximo a aguardar
$maxIdle = [timespan] "00:30:00"

# Usuários para ignorar de serem fechados
$usersIgnored = 'Admin|user001|user002|user003'

query user | Select-Object -Skip 1 | Where-Object { $_ -notmatch $usersIgnored -and $_ -notmatch '>' } | ForEach-Object {

    $columns = $_ -split '\s+'
    $username = $columns[1]
    $sessionId = $columns[2]
    $idle = $columns[5]
    $QuserIdleTime = $idle
    $QuserIdleTime = $QuserIdleTime.Replace('+', '.')
    $QuserIdleTime = $QuserIdleTime.Replace('.', '')
    

    if ($columns[2] -match '\d+$') {
        $sessionId = $sessionId -as [int]
    }

    if ($sessionId -is [int]) {
        Write-Output "[DESCONECTADO] Fechando sessão do usuário $username"
        logoff $sessionId
    }
        
        $sessionId = $columns[3]
        $state = $columns[4]

    if ($QuserIdleTime -as [int]) {
        $QuserIdleTime = "0:${QuserIdleTime}"
    }

    if ($QuserIdleTime -as [timespan]) {
        [timespan] $idleTime = $QuserIdleTime
        } 
   
    #if ($idle -gt $maxIdle -and [int]$sessionId -gt 0) {        
    if ($idleTime -gt $maxIdle -and $idle -notcontains ".") {        
        Write-Output "[OCIOSIDADE] Fechando sessão do usuário $username --> $sessionId -->  $idle -- $idleTime"
        logoff $sessionId        

      }
    
}
