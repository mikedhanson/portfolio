# Portfolio

## Site: https://michaelhanson.dev

## Local development

This site uses the Hugo Profile theme as a Git submodule.

Start a live-reloading preview at http://localhost:1313. The preview renders
in memory, so it does not change `docs` or deploy:

```powershell
.\build.ps1 -Watch
```

An additional preview is available at http://localhost:1314:

```powershell
.\build.ps1 -ProfilePreview
```

Both previews use `hugo-profile.yaml` and the `themes/hugo-profile` submodule.

Build the static site into `docs` without deploying:

```powershell
.\build.ps1
```

When the changes are ready, build the site and copy it to the Unraid Nginx
share:

```powershell
.\build.ps1 -Deploy
```

The deploy target defaults to `\\unraid.lan\appdata\swag\www\portfolio\docs`.
Matching files are overwritten; files that no longer exist in the generated
site are left in the destination.

`-DeployProfile` is also accepted as an alias. Deploy uses the production base
URL `https://michaelhanson.dev/` and copies the generated `docs` output to the
Unraid destination. Matching files are overwritten; files that no longer exist
in the generated site are left in the destination. Deploy never runs
automatically during preview or watch.

## Add new content 
hugo new posts/my-first-post.md
