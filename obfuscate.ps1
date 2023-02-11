
# run: ./obfuscate.ps1 -d ../lib -f *.dart -s symbols-dart.db -l func-example.list 
param ($d, $f, $s, $l)

$cmdSqlite3="$PSScriptRoot/sqlite-tools-win32-x86-3400100/sqlite3.exe"

# Table Name
$tableName="symbols"

# Sqlite3 File
$symbolStorage="$PSScriptRoot/$s"

# Symbol List
$symbolList="$PSScriptRoot/$l"

function makesureTableExist {
  & $cmdSqlite3 $symbolStorage "create table if not exists $tableName(orig text, dest text, file text, count integer);"
}

function saveMapping {
  $arg1=$args[0]
  $arg2=$args[1]
  $arg3=$args[2]
  $arg4=$args[3]
  & $cmdSqlite3 $symbolStorage "insert into $tableName values('$arg1', '$arg2', '$arg3', $arg4);"
}

function getExistedByOrig {
  $arg1=$args[0]
  & $cmdSqlite3 $symbolStorage "select dest from $tableName where orig='$arg1' order by rowid asc limit 1;"
}

function getRandomText {
  -join ((65..90) + (97..122) | Get-Random -Count 16 | % {[char]$_})
}

makesureTableExist

Get-ChildItem -path $d -recurse -Include $f | ForEach-Object {     
  $lineFile=([string]$_)
  #Write-Output "[start] $lineFile >>>>>>>>>>"

  Select-String -Pattern "^#" $symbolList -NotMatch | % {([string]$_).Split(":")[3]} | Sort-Object | Get-Unique | ForEach-Object { 
    $lineSymbol=([string]$_)
    #Write-Output $lineSymbol
    if (-not ([string]::IsNullOrEmpty($lineSymbol))) {
      $existedSymbol = $(getExistedByOrig $lineSymbol)

      $random = if (-not ([string]::IsNullOrEmpty($existedSymbol))) {
        $existedSymbol
      } else {
        $(getRandomText)
      }

      ((Get-Content -Path $lineFile -Raw) -replace $lineSymbol, $random) | Out-File -encoding utf8NoBOM $lineFile -NoNewline 

      $strArray = Select-String -Path $lineFile -Pattern $random 
      $count=$strArray.length

      if ($count -gt 0) {
        saveMapping $lineSymbol $random $lineFile $count
        Write-Output "[finish] $lineSymbol to $random, count: $count <<<<<<<<<<"
      }
    }
  }
}

# Render database content as SQL
& $cmdSqlite3 $symbolStorage .dump