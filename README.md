# PoshBot.GChat.EventHandler
> A PoshBot plugin to add event handling for Google Chat events emitted from the PoshBot.GChat.Backend.

## What is this?

This is a PoshBot plugin that enables handling for the following Google Chat events:
* ADDED_TO_SPACE
* REMOVED_FROM_SPACE
* CARD_CLICKED

This plugin is designed to be forked and customized to your own needs. As such, it will not be deployed to the PowerShell Gallery.

## Why would I use this?

This allows you to handle common events directly from PowerShell. Some examples:

* Creating a custom greeting when someone opens a DM with your bot
* Creating interactive cards that update messages during CARD_CLICKED events
* Adding custom logging to track events where DM's with a bot are closed or a bot is removed from a room

## How do I use this?

1. Fork this repo to your own account
2. Clone the forked repo into your PoshBot plugins folder
3. Edit the `psm1` file to customize it for your own needs
4. Add the plugin to the `plugin.psd1` configuration file, i.e.:

```powershell
@{
  'PoshBot.GChat.EventHandler' = @{
    '0.0.1' = @{
      Version = '0.0.1'
      Name = 'PoshBot.GChat.EventHandler'
      AdhocPermissions = @()
      ManifestPath = 'E:\Scripts\PoshBot\Plugins\PoshBot.GChat.EventHandler\PoshBot.GChat.EventHandler.psd1'
      Enabled = $True
    }
  }
}
```
