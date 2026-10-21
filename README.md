<h1>Export Enterprise App Notification Email Addresses</h1>

<h2>What it does</h2>

<p>This script is for auditing who gets certificate expiry warnings for your enterprise apps. It lists every enterprise application in your tenant along with the notification email addresses set on each one, then dumps the list to a CSV. It's handy for spotting apps with no notification email, or ones pointing at someone who has left.</p>

<h2>How it works</h2>

<ol>
  <li>Signs into Microsoft Graph with <code>Connect-MgGraph</code>. It only asks for <code>Application.Read.All</code>, so it's read-only and won't change anything in your tenant.</li>
  <li>Sets two variables at the top:
    <ul>
      <li><code>$outputPath</code> is where the CSV is saved, <code>certnotifemailoutput.csv</code> in whatever folder you ran the script from.</li>
      <li><code>$filter</code> limits results to enterprise apps by matching the <code>WindowsAzureActiveDirectoryIntegratedApp</code> tag, the same one the Entra portal uses for its Enterprise applications list.</li>
    </ul>
  </li>
  <li>Pulls every service principal that matches the filter with <code>Get-MgServicePrincipal -All</code>, asking Graph for only the fields it needs.</li>
  <li>Keeps these columns:
    <ul>
      <li><code>Id</code> (object ID)</li>
      <li><code>AppId</code></li>
      <li><code>DisplayName</code></li>
      <li><code>EmailAddresses</code> (the notification emails, joined into one cell with <code>;</code> between them)</li>
    </ul>
  </li>
  <li>Sorts the results by app name.</li>
  <li>Saves them to the CSV as UTF-8 so special characters in app names survive.</li>
  <li>Prints <code>Export complete</code> with the file path in green.</li>
</ol>

<h2>Prerequisites</h2>

<ul>
  <li>The Microsoft Graph PowerShell SDK (<code>Microsoft.Graph.Applications</code> module)</li>
  <li>An account that can use <code>Application.Read.All</code> and has a directory role that can read service principals, such as Global Reader</li>
</ul>

<h2>Notes / Limitations</h2>

<ul>
  <li>Apps with no notification email get an empty <code>EmailAddresses</code> cell, which is usually the interesting result.</li>
  <li>Service principals without the <code>WindowsAzureActiveDirectoryIntegratedApp</code> tag won't appear, so a few items visible in other views may be missing.</li>
  <li>The success message prints even if the export hit an error, so check for red error text above it.</li>
  <li>On a large tenant with thousands of apps, <code>-All</code> may take a little while to page through everything.</li>
</ul>
