module CmdTools
  RECOMMENDED_SHELL_SETTINGS = <<-EOS
# CmdTools
alias bak='cmd_tools backup'
alias tsh='cmd_tools trash'
alias emacs_stop='cmd_tools emacs_stop'
case $(uname) in
    # emacs_launch do not work satisfactory on Mac.
    "Darwin")
        function e(){
            files="$@"
            for file in ${files}
            do
                [ -e ${file} ] || touch ${file}
            done
            open -a /Applications/MacPorts/Emacs.app ${files}
        }
        alias em='/Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs --no-window-system --no-init-file'
        ;;
    *)
        alias e='cmd_tools emacs_launch --mode=gui'
        alias em='cmd_tools emacs_launch --mode=cui'
        ;;
esac
  EOS
end
