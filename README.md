<h2>Overview</h2>
<p><code>RenameAll.ps1</code> is a PowerShell script designed to rename all files in a specified directory. Users can provide a base filename, and the script appends or prepends a sequential index to each file's name. This script is useful for batch renaming files in an organised manner.</p>

<h3>Features:</h3>
<ul>
    <li>User-friendly graphical folder selection dialog.</li>
    <li>Choice of appending or prepending a sequential index to file names.</li>
    <li>Supports files with and without extensions.</li>
    <li>Comprehensive error handling and detailed logging.</li>
</ul>

<h2>Author</h2>
<ul>
    <li><strong>Name</strong>: Matt Dean</li>
    <li><strong>Contact</strong>: <a href="mailto:matt@mattdean.tech">matt@mattdean.tech</a></li>
    <li><strong>Version</strong>: 1.0.0</li>
    <li><strong>Created</strong>: 11/12/24</li>
</ul>

<hr>

<h2>Usage</h2>

<h3>Prerequisites</h3>
<p>Before running the script, ensure that PowerShell's execution policy allows the script to execute.</p>

<h4>Temporarily Bypass Execution Policy:</h4>
<pre><code>Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass</code></pre>

<h4>Revert Execution Policy (IMPORTANT):</h4>
<p>After running the script, reset the policy to ensure security:</p>
<pre><code>Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Restricted</code></pre>

<h3>Running the Script</h3>
<ol>
    <li><strong>Download the Script:</strong> Save <code>RenameAll.ps1</code> to your desired location.</li>
    <li><strong>Open PowerShell:</strong> Run PowerShell as Administrator (optional if execution policy is bypassed).</li>
    <li><strong>Run the Script:</strong> Execute the script using the following command:
        <pre><code>.\RenameAll.ps1</code></pre>
    </li>
    <li><strong>Follow Prompts:</strong>
        <ul>
            <li>Select a directory using the graphical dialog.</li>
            <li>Enter a base filename (e.g., <code>my-file</code>).</li>
            <li>Choose whether to append or prepend the sequential index.</li>
        </ul>
    </li>
    <li><strong>View Results:</strong> All files in the directory will be renamed based on your inputs.</li>
</ol>

<hr>

<h2>Example</h2>
<h3>Input</h3>
<p>Directory contents:</p>
<pre><code>image1.jpg

<p>User inputs:</p>
<ul>
    <li>Base filename: <code>project</code></li>
    <li>Placement choice: Append</li>
</ul>

<h3>Output</h3>
<p>Renamed directory contents:</p>
<pre><code>project-1.jpg

<hr>

<h2>Script Details</h2>
<h3>Key Functions</h3>
<h4>Select-FolderDialog</h4>
<p>Opens a graphical folder selection dialog. Returns the selected directory path or exits if no folder is selected.</p>

<h4>File Renaming Logic</h4>
<ol>
    <li>Prompts the user for a base filename.</li>
    <li>Asks whether the sequential index should be appended or prepended.</li>
    <li>Iterates through all files in the directory:
        <ul>
            <li>Constructs a new filename with the base name and index.</li>
            <li>Ensures file extensions are preserved.</li>
            <li>Renames the file while handling any errors.</li>
        </ul>
    </li>
</ol>

<hr>

<h2>Error Handling</h2>
<p>The script includes robust error handling:</p>
<ul>
    <li><strong>Invalid Directory:</strong> If the selected directory does not exist.</li>
    <li><strong>No Files:</strong> If no files are found in the selected directory.</li>
    <li><strong>File-Specific Errors:</strong> Handles issues during file renaming and logs the specific error message.</li>
</ul>

<hr>

<h2>Notes</h2>
<ol>
    <li><strong>Execution Policy:</strong> Ensure that PowerShell's execution policy allows the script to run. Use the bypass method for temporary execution.</li>
    <li><strong>Extensions:</strong> The script supports files with and without extensions.</li>
    <li><strong>Large Directories:</strong> Handles large numbers of files but may take longer depending on system performance.</li>
</ol>

<hr>

<h2>License</h2>
<p>This script is free to use and modify. Attribution to the original author is appreciated.</p>