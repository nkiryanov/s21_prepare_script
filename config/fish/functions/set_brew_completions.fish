function set_brew_completions --description="set brew completions if fish installed not frow brew itself"
  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
  end

  if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
  end
end;