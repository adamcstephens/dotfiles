def arg-or-env [arg: any, key: string, --required: bool = false] {
  if $arg != null and $arg != "" {
    $arg
  } else if $key != null and $key != "" {
    $key
  } else if $required {
    let span = (metadata $arg).span;
    error make {
        msg: "arg or env variable not set",
        start: $span.start,
        end: $span.end
    }
  }
}

export def forgejo-post-comment [api_url: string, api_token: string, pr_number: string, body: string] {
  let url = $"($api_url)/pulls/$($pr_number)/reviews"
  print $"(ansi green)Posting comment to $url(ansi reset)"
  (http post --headers [Authorization $"token ($api_token)"] --content-type application/json
    $url
    {body: $body,}
  )
}

export def forgejo-post-to-pr [api_url: string, api_token: string, branch: string, body: string, title: string] {
  let pr_check = forgejo-pr-check $api_url $api_token $branch

  if (($pr_check | length) > 0) {
    let pr = $pr_check | first
    print $"✅ Pull request number ($pr.number) already exists for branch ($branch), updating existing PR"
    (http patch --headers [Authorization $"token ($api_token)"] --content-type application/json
      $"($api_url)/pulls/($pr.number)"
      {
        title: $title,
        body: $body,
        base: main,
      }
    )
  } else {
    print $"⭐ Creating new pull request for branch ($branch)"
    (http post --headers [Authorization $"token ($api_token)"] --content-type application/json
      $"($api_url)/pulls"
      {
        title: $title,
        body: $body,
        base: main,
        head: $branch,
      }
    )
  }
}

export def forgejo-pr-check [api_url: string, api_token: string, branch: string] {
  mut pr_id: int = 0
  mut pr_exists: bool = false

  (http get --headers [Authorization $"token ($api_token)"] $"($api_url)/pulls?state=open" | each { |pr|
    if ($pr.head.ref == $branch) { $pr }
  })
}

export def git-ensure-email [name: string, email: string] {
  if (git config user.email | lines) == [] {
    print "✏️ Setting git name and email from env"
    git config user.name $name
    git config user.email $email
  }
}

export def git-prep-workdir [--base-remote: string = "upstream", branch: string, --reset: bool = true, --base: string, --dest-remote: string = "origin"] {
  let worktree_dir: string = $".worktree/($branch)"

  let worktree_args = ["--lock", "-b", $branch, $"($base_remote)/($base)"]

  if ($reset) {
    if ($worktree_dir | path exists) {
      print $"🗑️ (ansi yellow)Removing previous worktree at ($worktree_dir)(ansi reset)"
      git worktree remove -ff $worktree_dir
    }

    do { git branch -D $branch } | complete
    do { git push $dest_remote --delete $branch } | complete

    git fetch $base_remote $"($base):($base)"
  }

  if not ($worktree_dir | path exists) {
    print $"⭐ (ansi blue)Creating worktree for branch ($branch), at ($worktree_dir), on base ($base)(ansi reset)"
    git worktree add $worktree_dir ...$worktree_args
  }

  $worktree_dir
}
