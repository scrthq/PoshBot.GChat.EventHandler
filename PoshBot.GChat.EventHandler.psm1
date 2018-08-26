function AddedToSpace {
    [PoshBot.BotCommand(
        Permissions = 'Admin',
        HideFromHelp = $true,
        Command = $false,
        TriggerType = 'Event',
        MessageType = 'Message',
        MessageSubType = 'ChannelJoined'
    )]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    $originalMessage = ConvertFrom-Json $Global:PoshBotContext.ParsedCommand.CommandString
    Import-Module PSGSuite -MinimumVersion "2.13.0"
    Import-Module PoshBot.GChat.Backend
    $text = switch ($originalMessage.space.type) {
        DM {
            "Thanks for adding me to your DMs, <$($originalMessage.user.name)>!"
        }
        Room {
            "Thanks for adding me to the room, <$($originalMessage.user.name)>!"
        }
    }
    New-PoshBotTextResponse -Text $text
}
function RemovedFromSpace {
    [PoshBot.BotCommand(
        Permissions = 'Admin',
        HideFromHelp = $true,
        Command = $false,
        TriggerType = 'Event',
        MessageType = 'Message',
        MessageSubType = 'ChannelLeft'
    )]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    $originalMessage = ConvertFrom-Json $Global:PoshBotContext.ParsedCommand.CommandString
    Import-Module PSGSuite -MinimumVersion "2.13.0"
    Import-Module PoshBot.GChat.Backend
    
    # Empty for now since the bot is unable to send a message to a space it was removed from.
    # Maybe add logging specific to the implementation?
}

function CardClicked {
    [PoshBot.BotCommand(
        Permissions = 'Admin',
        HideFromHelp = $true,
        Command = $false,
        TriggerType = 'Event',
        MessageType = 'PresenceChange' # Hack for now since Google Chat doesn't support presence change but CardClicked is not currently available as a message type. This maps to CARD_CLICKED events sent from Google Chat only!
    )]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    $originalMessage = ConvertFrom-Json $Global:PoshBotContext.ParsedCommand.CommandString
    $actionMethod = $originalMessage.action.actionMethodName
    $actionParameters = $originalMessage.action.parameters
    Import-Module PSGSuite -MinimumVersion "2.13.0"
    Import-Module PoshBot.GChat.Backend
    switch ($actionMethod) {
        launchNuke {
            Add-GSChatKeyValue -TopLabel "Keys Decrypted" -Content $actionParameters.value | Add-GSChatCardSection | Add-GSChatImage -ImageUrl "https://media.giphy.com/media/iyKm1yNjeSebe/giphy.gif" -LinkImage | Add-GSChatCardSection -SectionHeader "BOOM" | Add-GSChatCard | New-PoshBotGChatCardResponse -Text "The nukes have been launched! Original text: $($originalMessage.message.text)"
        }
        unleashHounds {
            Add-GSChatImage -ImageUrl "https://media.giphy.com/media/TVCqfX7rLyMuY/giphy.gif" -LinkImage | Add-GSChatCardSection -SectionHeader "GRRRRRR" | Add-GSChatCard | New-PoshBotGChatCardResponse -Text "The hounds have been unleashed! Original text: $($originalMessage.message.text)"
        }
        default {
            New-PoshBotGChatCardResponse -Text "There is no action for the action method requested: [$actionMethod]"
        }
    }
}