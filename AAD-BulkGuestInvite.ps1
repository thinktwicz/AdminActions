<#
  API Permisions: Depending on which option you want in the API Permissions for the App select the correct invite.all Delegate or Application

#>
Import-Module MSAL.PS

$clientid = "Your Client ID"
$tenantid = "Your Tenant ID"

<#
  Pick option for MSALToken

  Below you have two options depending on how you want the message to look like from microsoft
  If you use MSALToken onBehalf of Signed in User the Subject will read
  User at CompanyName invited you 
  If you use MSALToken Application the Subject will read
  CompanyName invited you
#>

# OnBehalf of Signed in User (Delegate Permissions)
#$MSALtoken = Get-MsalToken -Interactive -ClientId $clientID -TenantId $tenantID

# Application (Application Permissions)
#$MSALtoken = Get-MsalToken  -ClientId $clientID -TenantId $tenantID -ClientSecret (ConvertTo-SecureString 'ThePasswordakaSecret' -AsPlainText -Force)

#header token
$headers  = @{Authorization = "Bearer $($MSALtoken.accesstoken)" }

<#
  Create a loop and run through list of emails to toss out
  foreach(thing in list)
  {
    update email
    invoke-rest
    add to other things if you want
  }
#>

# what is the user we are sending to?
$Email = 'email of person you want to invite'

# what URL do we direct them to? Could be direct to App URL if you so wanted
$redirectURL = "https://myapps.microsoft.com"
#api endpoint
$apiUrl = "https://graph.microsoft.com/v1.0/invitations"

# lets make the Json body structure
# we want to send the email invite so thats true - default is false

<#
  Some of the options we can put in the body
{
  "invitedUserDisplayName": "string",
  "invitedUserEmailAddress": "string",
  "invitedUserMessageInfo": {"@odata.type": "microsoft.graph.invitedUserMessageInfo"},
  "sendInvitationMessage": false,
  "inviteRedirectUrl": "string",
  "inviteRedeemUrl": "string",
  "status": "string",
  "invitedUser": {"@odata.type": "microsoft.graph.user"},
  "invitedUserType": "string"
}

#>


$body = 
@"
{
    "inviteduserEmailAddress" : "$($Email)",
    "inviteRedirectUrl" : "$($redirectURL)",
    "sendInvitationMessage" : "true"
}
"@

# Build the overall Request Body
$RequestBody = @{

            Uri = $apiUrl
            headers  = $headers
            method = 'POST'
            Contenttype = "application/json" 
            Body = $body
}
#//

# Capture the Response 
$Response = Invoke-RestMethod @RequestBody
 

<#
Response Details we get back

@odata.context          : https://graph.microsoft.com/v1.0/$metadata#invitations/$entity
id                      : 
inviteRedeemUrl         : 
invitedUserDisplayName  : 
invitedUserType         : Guest
invitedUserEmailAddress : 
sendInvitationMessage   : True
inviteRedirectUrl       : https://myapps.microsoft.com/
status                  : PendingAcceptance
invitedUserMessageInfo  : @{messageLanguage=; customizedMessageBody=; ccRecipients=System.Object[]}
invitedUser             : @{id=}Object ID of the user that was just created

#>

# Now we have a new user what do you want to do with them? Add to Group, Assign a Role, Put in an Access Package? Use the UserID to do this
$Response.invitedUser.id




















