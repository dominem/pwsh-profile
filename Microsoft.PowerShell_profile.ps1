function global:prompt {
    # Returns customized PowerShell prompt.
    #
    # Default format:
    # CMD# TIME PWDPART > 
    #
    # If git repo is initialized it will use the following format:
    # CMD# TIME PWDPART BRANCH >
    #
    # The PWDPART displays max. 2 parts of current working dir:
    #
    #          Working directory          |          Result
    # C:\                                 | 1 18:11:37 C > 
    # C:\Users                            | 2 18:11:37 C\Users > 
    # C:\Users\dominem                    | 3 18:11:37 Users\dominem > 
    # C:\Users\dominem\repos              | 4 18:11:37 dominem\repos > 

    # 1. Print the history ID of the next command.
    # The at sign creates an array in case only one history item exists.
    $history = @(Get-History)
    Write-Host -Object "$($history.Length + 1) " -NoNewline -ForegroundColor DarkGreen

    # 2. Print time in HH:mm:ss format.
    Write-Host -Object "$(Get-Date -Format 'HH:mm:ss') " -NoNewline -ForegroundColor DarkYellow

    # 3. Print part of the current working directory.
    $pwd_arr = $PWD -split "\\"
    $l = $pwd_arr.Length
    if ($l -eq 2) {
        if ($pwd_arr[1]) {
            $pwd_path = $PWD -Replace ':',''
        } else {
            $pwd_path = $PWD -Replace ':\\',''
        }
    } else {
        $pwd_path = "$($pwd_arr[$l-2])\$($pwd_arr[$l-1])"
    }
    Write-Host -Object "$pwd_path " -NoNewline -ForegroundColor DarkCyan

    $git_branch = $(git rev-parse --abbrev-ref HEAD)
    if ($git_branch) {
        Write-Host -Object "$git_branch " -NoNewline -ForegroundColor Red
    }

    # 4. Return the actual command line prompt.
    return "> "
}