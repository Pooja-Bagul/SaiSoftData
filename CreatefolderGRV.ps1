function Read-OutlookEmails {
    param (
        [string]$specificSender,
        [string]$subjectFilter,
        [string]$downloadFolder
    )

    # Create an instance of the Outlook application
    $outlook = New-Object -ComObject Outlook.Application
    
    # Get the MAPI namespace
    $mapi = $outlook.GetNamespace("MAPI")
    
    # Access the inbox folder
    $inbox = $mapi.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
    
    # Get the items in the inbox
    $messages = $inbox.Items

    # Loop through the messages and print details
    foreach ($message in $messages) {
        try {
            # Check if the sender and subject match
            if ($message.SenderEmailAddress -eq $specificSender -and $message.Subject -match $subjectFilter) {
                
                Write-Host "Subject: $($message.Subject)"
                Write-Host "Sender: $($message.SenderName)"
                Write-Host "Received Time: $($message.ReceivedTime)"
                Write-Host "Body:"
                Write-Host $message.Body  # Print the body of the email
                Write-Host "Attachments:"

                # Loop through attachments
                foreach ($attachment in $message.Attachments) {
                    $attachmentFilePath = Join-Path -Path $downloadFolder -ChildPath $attachment.FileName
                    Write-Host " - Downloading: $($attachment.FileName)"
                    $attachment.SaveAsFile($attachmentFilePath)  # Save the attachment
                }

                Write-Host ("-" * 40)
            }
        } catch {
            Write-Host "An error occurred: $_"
        }
    }
}

# Replace with the specific email address
$specificSender = "pranjal.tripathi@celebaltech.com"

# Replace with the specific subject to filter
$subjectFilter = "Your timesheet request is approved."

# Specify the folder to save attachments
$downloadFolder = "C:\Path\To\Download"

# Call the function
Read-OutlookEmails -specificSender $specificSender -subjectFilter $subjectFilter -downloadFolder $downloadFolder