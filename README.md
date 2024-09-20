# insios/smarthost

A smarthost is an mail transfer agent, or mail relay via which third parties can
send emails and have them forwarded on to the email recipient's email servers.

## Description

This image allows you...

## TLDR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Features

### Auth

### DKIM

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

### Proxy Protocol

## Configuration

### ENV

### YAML

### conf files

<nav aria-label="Repository files" class="UnderlineTabbedInterface__StyledUnderlineWrapper-sc-4ilrg0-0 duyuyF"><ul role="list" class="UnderlineTabbedInterface__StyledUnderlineItemList-sc-4ilrg0-1 gJyWUl"><li class="Box-sc-g0xbh4-0 hUCRAk"><a href="#" aria-current="page" class="UnderlineTabbedInterface__StyledUnderlineItem-sc-4ilrg0-2 HZeLY"><span data-component="icon"><svg aria-hidden="true" focusable="false" role="img" class="octicon octicon-book" viewBox="0 0 16 16" width="16" height="16" fill="currentColor" style="display:inline-block;user-select:none;vertical-align:text-bottom;overflow:visible"><path d="M0 1.75A.75.75 0 0 1 .75 1h4.253c1.227 0 2.317.59 3 1.501A3.743 3.743 0 0 1 11.006 1h4.245a.75.75 0 0 1 .75.75v10.5a.75.75 0 0 1-.75.75h-4.507a2.25 2.25 0 0 0-1.591.659l-.622.621a.75.75 0 0 1-1.06 0l-.622-.621A2.25 2.25 0 0 0 5.258 13H.75a.75.75 0 0 1-.75-.75Zm7.251 10.324.004-5.073-.002-2.253A2.25 2.25 0 0 0 5.003 2.5H1.5v9h3.757a3.75 3.75 0 0 1 1.994.574ZM8.755 4.75l-.004 7.322a3.752 3.752 0 0 1 1.992-.572H14.5v-9h-3.495a2.25 2.25 0 0 0-2.25 2.25Z"></path></svg></span><span data-component="text" data-content="README">README</span></a></li><li class="Box-sc-g0xbh4-0 hUCRAk"><a href="#" class="UnderlineTabbedInterface__StyledUnderlineItem-sc-4ilrg0-2 HZeLY"><span data-component="icon"><svg aria-hidden="true" focusable="false" role="img" class="octicon octicon-law" viewBox="0 0 16 16" width="16" height="16" fill="currentColor" style="display:inline-block;user-select:none;vertical-align:text-bottom;overflow:visible"><path d="M8.75.75V2h.985c.304 0 .603.08.867.231l1.29.736c.038.022.08.033.124.033h2.234a.75.75 0 0 1 0 1.5h-.427l2.111 4.692a.75.75 0 0 1-.154.838l-.53-.53.529.531-.001.002-.002.002-.006.006-.006.005-.01.01-.045.04c-.21.176-.441.327-.686.45C14.556 10.78 13.88 11 13 11a4.498 4.498 0 0 1-2.023-.454 3.544 3.544 0 0 1-.686-.45l-.045-.04-.016-.015-.006-.006-.004-.004v-.001a.75.75 0 0 1-.154-.838L12.178 4.5h-.162c-.305 0-.604-.079-.868-.231l-1.29-.736a.245.245 0 0 0-.124-.033H8.75V13h2.5a.75.75 0 0 1 0 1.5h-6.5a.75.75 0 0 1 0-1.5h2.5V3.5h-.984a.245.245 0 0 0-.124.033l-1.289.737c-.265.15-.564.23-.869.23h-.162l2.112 4.692a.75.75 0 0 1-.154.838l-.53-.53.529.531-.001.002-.002.002-.006.006-.016.015-.045.04c-.21.176-.441.327-.686.45C4.556 10.78 3.88 11 3 11a4.498 4.498 0 0 1-2.023-.454 3.544 3.544 0 0 1-.686-.45l-.045-.04-.016-.015-.006-.006-.004-.004v-.001a.75.75 0 0 1-.154-.838L2.178 4.5H1.75a.75.75 0 0 1 0-1.5h2.234a.249.249 0 0 0 .125-.033l1.288-.737c.265-.15.564-.23.869-.23h.984V.75a.75.75 0 0 1 1.5 0Zm2.945 8.477c.285.135.718.273 1.305.273s1.02-.138 1.305-.273L13 6.327Zm-10 0c.285.135.718.273 1.305.273s1.02-.138 1.305-.273L3 6.327Z"></path></svg></span><span data-component="text" data-content="License">License</span></a></li></ul></nav>

## Helm chart

See chart [README.md](chart)
