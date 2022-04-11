source ~/.config/homemadeconfig/.bashrc-base
source ~/.config/homemadeconfig/.bashrc-aliases

# For repo
PATH="${HOME}/.bin:${PATH}"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/alex/google-cloud-sdk/path.bash.inc' ]; then . '/home/alex/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/alex/google-cloud-sdk/completion.bash.inc' ]; then . '/home/alex/google-cloud-sdk/completion.bash.inc'; fi
