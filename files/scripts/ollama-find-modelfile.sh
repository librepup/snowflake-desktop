#!/usr/bin/env zsh

ollama-find-modelfile-function() {
    if [[ -z $1 ]]; then
        echo -e "Error, No Model Name Provided!\nPlease run this Command like so:\n - 'ollama-find-modelfile MyModel_0B:A_B_C'\n"
        return 1
    else
        local model="${1%% *}"
        echo -e "Searching for Model '${model}'...\n"
        ollama show --modelfile "$model"
    fi
}

ollama-find-modelfile() {
    ollama-find-modelfile-function "$@"
}

ollamaFindModelfile() {
    ollama-find-modelfile-function "$@"
}

ollamafind() {
    ollama-find-modelfile-function "$@"
}
