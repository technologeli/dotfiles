if type -q fnm
    fnm env --use-on-cd | source
end
# fnm
set PATH "/home/eli/.local/share/fnm" $PATH
fnm env | source
