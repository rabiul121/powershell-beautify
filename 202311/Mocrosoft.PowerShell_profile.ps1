Clear-Host
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module posh-git
# Import-Module oh-my-posh
# $omp_config = "C:\Users\robi\.config\powershell\robi.omp.json"
# oh-my-posh --init --shell pwsh --config "C:\Users\robi\.config\powershell\robi.omp.json" | Invoke-Expression

# $random_theme = Get-Content "C:\Users\robi\.config\powershell\mythemes.txt" | Get-Random
# echo $random_theme.name
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\$random_theme" | Invoke-Expression




# Select a random Oh My Posh theme
$themes = Get-Content -Path "C:\Users\robi\.config\powershell\mythemes.txt"
$selected_theme = $themes | Get-Random
# $base_url = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/"
$base_url = "C:\Users\robi\AppData\Local\Programs\oh-my-posh\themes\"
$terminal_theme_url = "${base_url}${selected_theme}.omp.json"

# Set the random theme to an environment variable
Set-Item -Path Env:TERMINAL_THEME -Value $terminal_theme_url

# Print the theme name when your terminal session starts
# echo "Oh My Posh Theme: $selected_theme"

oh-my-posh init pwsh --config $env:TERMINAL_THEME | Invoke-Expression


# oh-my-posh init pwsh --config 'C:\Users\robi\AppData\Local\Programs\oh-my-posh\themes\catppuccin.omp.json' | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias yt yt-dlp.exe
Set-Alias x exit
Set-Alias c clear

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }
