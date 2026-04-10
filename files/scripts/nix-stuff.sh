#!/usr/bin/env zsh
# Useful Nix-Related Functions

# Home-Manager
home-rebuild() {
    local localUsername
    localUsername=$USER
    home-manager switch --flake /etc/nixos#${localUsername} "$@"
}

home-garbage() {
    if command -v home-manager >/dev/null; then
        home-manager expire-generations "-1 days"
        return 0
    else
        echo "Could Not Find Home-Manager Binary, Aborting..."
        return 1
    fi
}

home-generations() {
    if ! command -v home-manager >/dev/null; then
        echo "Error: Home-Manager Binary Not Found, Aborting..." >&2
        return 1
    fi
    if [[ -d ~/.local/state/nix/profiles ]]; then
        ls -l ~/.local/state/nix/profiles/ | grep home-manager "$@"
        return 0
    elif [[ -d ~/.local/state/nix/profiles ]] && ! command -v home-manager >/dev/null; then
        echo "Could Not Find Home-Manager Binary, Aborting..."
        return 1
    else
        echo "Encountered an Error, Aborting..."
        return 1
    fi
    return 0;
}

# Generic/Miscellanious
orebuild() {
    doas nixos-rebuild switch --flake /etc/nixos#snowflake "$@"
}
ore() {
    doas nixos-rebuild switch --flake /etc/nixos#snowflake "$@"
}
rebuild() {
    local lochost
    local confpath
    if [[ -f /etc/nixos/flake.nix ]]; then
        if [[ -n "$confpath" ]]; then
            unset confpath
        fi
        lochost=$(grep -oP 'nixosConfigurations\.\K[^[:space:]]+' /etc/nixos/flake.nix | head -n 1)
        if [[ -z "$lochost" ]]; then
            printf "Couldn't Detect Flake Hostname, Enter Manually? (y/n): " >&2
            local ans
            read -r ans
            if [[ "$ans" =~ ^[yY]$ ]]; then
                read -r -p "Enter your Host/Flake Name: " lochost
                if [[ -z "$lochost" ]]; then
                    echo "Error: No Host/Flake Name Provided or Faulty, Aborting..." >&2
                    return 1
                fi
            else
                echo "Aborting Hostname Detection..." >&2
                return 1
            fi
        fi
        confpath="--flake /etc/nixos#${lochost}"
    elif [[ -f /etc/nixos/configuration.nix ]]; then
        if [[ -n "$confpath" ]]; then
            unset confpath
        fi
        lochost=$(grep -oP 'hostName\s*=\s*"\K[^"]+' /etc/nixos/configuration.nix | head -n 1)
        if [[ -z "$lochost" ]]; then
            echo "Warning: Couldn't Detect Hostname for your Configuration (.nix). Proceeding without... (As it is not Integral)"
        fi
        export confpath="/etc/nixos/configuration.nix"
    else
        echo "Error: Can't determine Config Type: Neither Flake, nor Configuration (.nix), Aborting..." >&2
        return 1
    fi
    if [[ -n "$_esc_util" ]]; then
        unset _esc_util
    fi
    local _esc_util
    local cmd
    if command -v doas >/dev/null; then
        export _esc_util="doas"
    elif command -v sudo >/dev/null; then
        export _esc_util="sudo"
    elif command -v su >/dev/null; then
        export _esc_util="su"
    else
        echo "Error: No Escalation Utility Found (Doas, Sudo, SU), Aborting..." >&2
        return 1
    fi
    _extend_cmd() {
        if [[ "$cmd" == "" ]] || [[ -z "$cmd" ]]; then
            if [[ "$_esc_util" == "su" ]]; then
                export cmd="su root -c \"nixos-rebuild switch ${confpath}\""
            else
                export cmd="${_esc_util} nixos-rebuild switch ${confpath}"
            fi
        else
            if [[ "$cmd" == *nixos-rebuild\ switch* ]]; then
                if [[ "$_esc_util" == "su" ]]; then
                    export _comp_cmd_nana="su root -c \"nixos-rebuild switch ${confpath}\""
                else
                    export _comp_cmd_nana="${_esc_util} nixos-rebuild switch ${confpath}"
                fi
                if [[ "$cmd" == "$_comp_cmd_nana" ]]; then
                    export cmd="${cmd}"
                else
                    echo "Error: Command Mismatch Encountered, Aborting..."
                    return 1
                fi
            else
                echo "Error: The \"\$cmd\" Variable was Externally Overwritten, This makes the Rebuild Command Unrecoverable, Aborting..."
                return 1
            fi
        fi
    }
    _extend_cmd
    if [[ "$_verbose_mode" == 1 ]]; then
        echo "Executing: $cmd $confpath $@"
    fi
    if [[ "$_rebuild_test_mode" == 1 ]]; then
        export cmd="echo \"${cmd}\""
    fi
    if eval "$cmd" "$@"; then
        echo "Successfully Rebuilt NixOS."
        return 0
    else
        echo -e "Encountered an Error Rebuilding NixOS...\nDo you want to Generate a Rebuild Script to Manually Execute? (y/n): "
        read -r _gen_build_script_ans
        if [[ "$_gen_build_script_ans" =~ ^[yY]$ ]]; then
            local _rand_re_script_fin
            _rand_re_script_fin=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12)
            _re_script_name="${_rand_re_script_fin}"
            if [[ ! -f /tmp/"${_re_script_name}" ]]; then
                touch /tmp/"${_re_script_name}"
            else
                rm /tmp/"${_re_script_name}"
                touch /tmp/"${_re_script_name}"
                fi
            echo "${cmd} $@" >> /tmp/"${_re_script_name}"
            chmod a+x /tmp/"${_re_script_name}"
            echo -e "Generated Rebuild Script at: '/tmp/${_re_script_name}'.\nExecute it by Running '${_esc_util} /tmp/${_re_script_name}'.\n"
            return 0
        else
            echo "Aborting..."
            return 1
        fi
    fi
}

garbage() {
    local _esc_util
    if command -v doas >/dev/null 2>&1; then
        _esc_util="doas"
    elif command -v sudo >/dev/null 2>&1; then
        _esc_util="sudo"
    elif command -v su >/dev/null 2>&1; then
        _esc_util="su"
    else
        echo "No Escalation Utility Found, Aborting..." >&2
        return 1
    fi
    echo "Detected '${_esc_util}' as Escalation Utility, Continuing..."
    local _success_state=0
    local _cmd_response_code
    if [[ "$_esc_util" == "doas" ]]; then
        if [[ "$_debug_mode" == 1 ]]; then
            echo "doas echo \"nix-collect-garbage -d \\"$@\\"\" && _success_state=1 || _success_state=2\""
            export _cmd_response_code=$?
            export _skip_work=1
        fi
        if [[ "$_skip_work" == 1 ]]; then
            echo "Skipping Work..."
        else
            doas echo "nix-collect-garbage -d \"$@\"" && _success_state=1 || _success_state=2
            export _cmd_response_code=$?
        fi
    elif [[ "$_esc_util" == "sudo" ]]; then
        if [[ "$_debug_mode" == 1 ]]; then
            echo "sudo echo \"nix-collect-garbage -d \\"$@\\"\" && _success_state=1 || _success_state=2\""
            export _cmd_response_code=$?
            export _skip_work=1
        fi
        if [[ "$_skip_work" == 1 ]]; then
            echo "Skipping Work..."
        else
            sudo echo "nix-collect-garbage -d \"$@\"" && _success_state=1 || _success_state=2
            export _cmd_response_code=$?
        fi
    elif [[ "$_esc_util" == "su" ]]; then
        if [[ "$_debug_mode" == 1 ]]; then
            echo "su root -c \"echo \\"nix-collect-garbage -d \\"$@\\"\\"\" && _success_state=1 || _success_state=2\""
            export _cmd_response_code=$?
            export _skip_work=1
        fi
        if [[ "$_skip_work" == 1 ]]; then
            echo "Skipping Work..."
        else
            su root -c "echo \"nix-collect-garbage -d \"$@\"\"" && _success_state=1 || _success_state=2
            export _cmd_response_code=$?
        fi
    fi
    if [[ $cmd_response_code -eq 0 ]]; then
        echo "Successfully Collected Garbage\!"
        return 0
        unset _cmd_response_code
        unset _esc_util
        unset _success_state
    else
        echo "Encountered an Error Collecting Garbage, Aborting..."
        unset _cmd_response_code
        unset _esc_util
        unset _success_state
        return 1
    fi
}
repair() {
    if command -v doas >/dev/null; then
        if [[ "$_debug_mode" != 1 ]]; then
            doas nix-store --verify --repair "$@" && _success_state=1 || _success_state=2
            echo "Successfully Repaired and Verified Nix-Store Integrity."
            return 0
        else
            echo "Skipping Work..."
            echo "doas nix-store --verify --repair \"$@\" && _success_state=1 || _success_state=2\""
            return 0
        fi
    elif command -v sudo >/dev/null; then
        if [[ "$_debug_mode" != 1 ]]; then
            sudo nix-store --verify --repair "$@" && _success_state=1 || _success_state=2
            echo "Successfully Repaired and Verified Nix-Store Integrity."
            return 0
        else
            echo "Skipping Work..."
            echo "sudo nix-store --verify --repair \"$@\" && _success_state=1 || _success_state=2\""
            return 0
        fi
    elif command -v su >/dev/null; then
        if [[ "$_debug_mode" != 1 ]]; then
            su root -c "nix-store --verify --repair $@" && _success_state=1 || _success_state=2
            echo "Successfully Repaired and Verified Nix-Store Integrity."
            return 0
        else
            echo "Skipping Work..."
            echo "su root -c \"nix-store --verify --repair $@\" && _success_state=1 || _success_state=2\""
            return 0
        fi
    else
        echo "No Escalation Utility Found, Aborting..."
        return 1
    fi
}
ns() {
    # Variables
    arg1=$1
    arg2=$2
    args=("$@")
    flags=(
        -p
        --packages
        --run
        --command
        --pure
        --version
        --quiet
        --expr
        --impure
    )
    # Detect Flags/Args
    is_flag() {
        local a="$1"
        for f in "${flags[@]}"; do
            [[ "$a" == "$f" ]] && return 0
            [[ "$a" == ${f}* ]] && return 0
        done
        return 1
    }
    # Sort and Index Flags/Args
    flag_index=-1
    for i in {1..$#args}; do
        for f in "${flags[@]}"; do
            if [[ "${args[$i]}" == "$f" ]]; then
                flag_index=$i
                break
            fi
        done
        (( flag_index != -1 )) && break
    done
    if (( flag_index == -1 )); then
        echo "Error: Invalid Argument Supplied, Please Verify your Arguments with the Nix-Shell Man-Page. (man nix-shell)"
        return 1
    fi
    if [[ "$_verbose_mode" == 1 ]]; then
        echo "Flag Found at Index: '${flag_index}'..."
    fi
    selected=()
    for (( j = flag_index + 1; j <= $#args; j++ )); do
        if is_flag "${args[$j]}"; then
            break
        fi
        selected+=("${args[$j]}")
    done
    if [[ "$_verbose_mode" == 1 ]]; then
        printf "[Selected]: "
        printf "%s\n" "${selected[@]}"
    fi
    # Detect The Users's Preferred Shell
    if command -v zsh >/dev/null && [[ "$SHELL" == *zsh* ]]; then
        nix-shell --run zsh "$@" && _shell_success=1 || { _shell_success=0; return 1 }
        if [[ "$_verbose_mode" == 1 ]]; then
            if [[ "$_shell_success" == 1 ]]; then
                echo "Successfully Ran Nix-Shell with ZSH."
            else
                echo "Error Running Nix-Shell with ZSH."
                return 1
            fi
        fi
        return 0
    elif command -v bash >/dev/null && [[ "$SHELL" == *bash* ]]; then
        nix-shell --run bash "$@" && _shell_success=1 || { _shell_success=0; return 1 }
        if [[ "$_verbose_mode" == 1 ]]; then
            if [[ "$_shell_success" == 1 ]]; then
                echo "Successfully Ran Nix-Shell with Bash."
            else
                echo "Error Running Nix-Shell with Bash."
                return 1
            fi
        fi
        return 0
    elif command -v fish >/dev/null && [[ "$SHELL" == *fish* ]]; then
        nix-shell --run fish "$@" && _shell_success=1 || { _shell_success=0; return 1 }
        if [[ "$_verbose_mode" == 1 ]]; then
            if [[ "$_shell_success" == 1 ]]; then
                echo "Successfully Ran Nix-Shell with Fish."
            else
                echo "Error Running Nix-Shell with Fish."
                return 1
            fi
        fi
        return 0
    elif [[ "$_force_xonsh" == 1 ]] || [[ "$_force_xonsh" == "true" ]] || command -v xonsh >/dev/null 2>&1 && { [[ "$SHELL" == *xonsh* ]] || grep -qiE 'xonsh' "$HOME/.zshrc" /etc/zshrc 2>/dev/null; }; then
        nix-shell --run xonsh "$@" 2>/dev/null && _shell_success=1 || {_shell_success=0; if [[ "$_verbose_mode" == 1 ]]; then echo "Encountered an Error Launching the Nix-Shell."; fi }
        if [[ "$_verbose_mode" == 1 ]]; then
            if [[ "$_shell_success" == 1 ]]; then
                echo "Successfully Ran Nix-Shell with Xonsh."
            else
                echo "Error Running Nix-Shell with Xonsh."
                return 1
            fi
        fi
        return 0
    else
        if command -v nix-shell >/dev/null; then
            if command -v bash >/dev/null; then
                nix-shell --run bash "$@" 2>/dev/null && _shell_success=1 || {_shell_success=0; if [[ "$_verbose_mode" == 1 ]]; then echo "Encountered an Error Launching the Nix-Shell."; fi }
                if [[ "$_verbose_mode" == 1 ]]; then
                    if [[ "$_shell_success" == 1 ]]; then
                        echo "Successfully Ran Nix-Shell with Bash (Fallback)."
                    else
                        echo "Error Running Nix-Shell with Bash (Fallback)."
                        return 1
                    fi
                fi
                return 0
            elif command -v sh >/dev/null; then
                nix-shell --run sh "$@" 2>/dev/null && _shell_success=1 || {_shell_success=0; if [[ "$_verbose_mode" == 1 ]]; then echo "Encountered an Error Launching the Nix-Shell."; fi }
                if [[ "$_verbose_mode" == 1 ]]; then
                    if [[ "$_shell_success" == 1 ]]; then
                        echo "Successfully Ran Nix-Shell with SH (Fallback)."
                    else
                        echo "Error Running Nix-Shell with SH (Fallback)."
                        return 1
                    fi
                fi
                return 0
            else
                echo "Unable to Find Viable Shell, Aborting..."
                return 1
            fi
        else
            echo "Could not Find Nix-Shell Command, Aborting..."
            return 1
        fi
    fi
}

nss() {
    nix-search --name "$@"
}
nsearch() {
    nix-search --name "$@"
}
no() {
    manix "$@"
}
nso() {
    manix "$@"
}

# Building
nixbuild() {
    echo "Did you mean \`buildnix\`?"
}

# Generations
nix-generations() {
    _get_esc_util_info() {
        if [[ -n "$_esc_util" ]]; then
            unset _esc_util
        fi
        if command -v doas >/dev/null; then
            export _esc_util="doas"
        elif command -v sudo >/dev/null; then
            export _esc_util="sudo"
        elif command -v su >/dev/null; then
            export _esc_util="su"
        else
            echo "Error: No Escalation Utility Recognized, Aborting..."
            return 1
        fi
    }
    _get_esc_util_info
    if [[ "$_esc_util" != "su" ]]; then
        local _thees_cmd_nao
        _thees_cmd_nao="${_esc_util} nix-env --list-generations --profile /nix/var/nix/profiles/system $@"
        if eval "$_thees_cmd_nao" "$@" > /dev/null 2>/dev/null &>/dev/null; then
            echo "--- NixOS Generations ---"
            if [[ "$_debug_mode" == 1 ]]; then
                echo "eval \"$_thees_cmd_nao\" \"$@\""
                return 0
            else
                eval "$_thees_cmd_nao" "$@"
                return 0
            fi
        else
            echo "Error Listing NixOS Generations, Aborting..."
            return 1
        fi
    else
        local _thees_cmd_nao
        _thees_cmd_nao="su root -c \"nix-env --list-generations --profile /nix/var/nix/profiles/system $@\""
        if eval "$_thees_cmd_nao" "$@" > /dev/null 2>/dev/null &>/dev/null; then
            echo "--- NixOS Generations ---"
            if [[ "$_debug_mode" == 1 ]]; then
                echo "eval \"$_thees_cmd_nao\" \"$@\""
                return 0
            else
                eval "$_thees_cmd_nao" "$@"
                return 0
            fi
        else
            echo "Error Listing NixOS Generations, Aborting..."
            return 1
        fi
    fi
}
generations() {
    echo -e 'NixOS Generations:\n'
    doas nix-env --list-generations --profile /nix/var/nix/profiles/system
    echo -e '\nHome-Manager Generations:\n'
    ls -l ~/.local/state/nix/profiles/ | grep home-manager
}
