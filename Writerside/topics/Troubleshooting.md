# Troubleshooting

## Post-updates

If you see an error while Memos' interface is loading, press F5 or right-click
the window and click reload.

This is caused by a stale WebView cache and also affects Memos' Docker
instances. It should happen only once right after the update.

## Linux

If Memospot starts but doesn't get past the loading screen, or the screen stays
white, you may have an issue with hardware acceleration on your GPU driver. This
is a common issue with Linux virtual machines.

Try running Memospot with the WebView acceleration disabled with the following
command:

```Shell
WEBKIT_DISABLE_COMPOSITING_MODE=1 memospot
```

If it solves your problem, you can disable the WebView acceleration permanently
with the following command:

```Shell
echo 'WEBKIT_DISABLE_COMPOSITING_MODE=1' | sudo tee -a /etc/environment
```

> You must restart your computer for this to take effect.
