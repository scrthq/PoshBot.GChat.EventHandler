function ADDED_TO_SPACE {
    [PoshBot.BotCommand(
        Permissions = 'Admin',
        HideFromHelp = $true,
        Command = $false,
        CommandName = 'ADDED_TO_SPACE',
        TriggerType = 'regex',
        Regex = '^ADDED_TO_SPACE.*'
    )]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    try {
        $originalMessage = ConvertFrom-Json ([String]$Arguments[0]).TrimStart('ADDED_TO_SPACE OriginalMessage: ')
    }
    catch {}
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
function REMOVED_FROM_SPACE {
    [PoshBot.BotCommand(
        Permissions = 'Admin',
        HideFromHelp = $true,
        Command = $false,
        CommandName = 'REMOVED_FROM_SPACE',
        TriggerType = 'regex',
        Regex = '^REMOVED_FROM_SPACE.*'
    )]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    try {
        $originalMessage = ConvertFrom-Json ([String]$Arguments[0]).TrimStart('ADDED_TO_SPACE OriginalMessage: ')
    }
    catch {}
    Import-Module PSGSuite -MinimumVersion "2.13.0"
    Import-Module PoshBot.GChat.Backend
    
    # Empty for now since the bot is unable to send a message to a space it was removed from. Maybe add logging specific to the implementation?
}

function CARD_CLICKED {
    [PoshBot.BotCommand(
        Permissions = 'Admin',
        HideFromHelp = $true,
        Command = $false,
        CommandName = 'CARD_CLICKED',
        TriggerType = 'regex',
        Regex = '^CARD_CLICKED.*'
    )]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    $argString = ([String]$Arguments[0]).Split(' ',2)[1]
    $actionMethod = ($argString.Split("ActionMethodName: ",2))[1].Split(" ",3)[1]
    $remaining = $argString.TrimStart("ActionMethodName: $actionMethod ActionMethodParams: ") -split " OriginalMessage: "
    try {
        $actionParameters = ConvertFrom-Json $remaining[0]
        $originalMessage = ConvertFrom-Json $remaining[1]
    }
    catch {}
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