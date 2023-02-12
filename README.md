# Simple Code Obfuscator - Powershell

![Windows](https://svgshare.com/i/ZhY.svg)
[![GitHub license](https://badgen.net/github/license/Naereen/Strapdown.js)](https://github.com/yongxin-tech/Powershell-Simple-Code-Obfuscator/blob/main/LICENSE)

This tool help you to obfuscate codes simply, especially in situation that no useful obfuscator of programming language, like swift, flutter.

The script read symbols from <code>func.list</code> file, replace symbols with random string, then store mappings into sqlite.


# Environment

The script is only tested on following environment,
* OS: Windows 10+
* ISE: Powershell 7.x

Bash/MacOS version, see: [Simple Code Obfuscator - MacOS bash](https://github.com/yongxin-tech/Bash-Simple-Code-Obfuscator)

# Usage

* Recommend: The script will overwrite the file directly, better use it on a separate branch

* Preparation: Create a <code>func.list</code> file, put it into script folder

  <code>func-example.list</code>
  ```
  #__model.CommonBc
  _getFacade
  _resultToMenu
  initMenu
  #__model.CommonDbManager
  _scriptV1
  ```

* Command: 
  ```powershell
  ./obfuscate.ps1 -d <code folder> -f <filter pattern> -s <name of sqlite db file> -l <file of symbol list> 
  ```

* Example: On Powershell
  ```powershell
  ./obfuscate.ps1 -d ../lib -f *.dart -s symbols-dart.db -l func-example.list 
  ```


# License

Copyright (c) 2023-present [Yong-Xin Technology Ltd.](https://yong-xin.tech/)

This project is licensed under the MIT License - see the [LICENSE](https://github.com/yongxin-tech/Powershell-Simple-Code-Obfuscator/blob/main/LICENSE) file for details.


