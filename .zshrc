#System-wide cd by folder name, ignoring build/trash/cache folders
cdf() {
  if [[ -z "$1" ]]; then
    echo "Usage: cdf <folder_name>"
    return 1
  fi

  local base_dir="/"
  local folder_name="$1"
  local matches

  #Find directories matching the name, excluding common unwanted paths
  matches=("${(@f)$(find "$base_dir" -type d -iname "*$folder_name*" \
            ! -path "*/.Trash-1000/*" \
            ! -path "*/target/*" \
            ! -path "*/.fingerprint/*" \
            ! -path "*/incremental/*" \
            ! -path "*/.cache/*" \
            ! -path "*/node_modules/*" \
            2>/dev/null)}")


  if (( ${#matches[@]} == 0 )); then
    echo "No folder found for: $folder_name"
    return 1
  elif (( ${#matches[@]} == 1 )); then
    cd "${matches[1]}"
  else
    echo "Multiple matches found:"
    for i in {1..${#matches[@]}}; do
      echo "$i) ${matches[i]}"
    done
    read -r "choice?Enter number to cd: "
    [[ $choice -ge 1 && $choice -le ${#matches[@]} ]] && cd "${matches[choice]}"
  fi

  pwd
}
