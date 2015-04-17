
![11910876](https://cloud.githubusercontent.com/assets/11910876/7189304/c483f1b0-e486-11e4-9a95-44a1243fea5d.png)
<h3>Transforms trx file into html</h3><br/>
Trxer is a new way to view Trx Reports,all you need is a browser<br/>
Trxer website: http://wingsrom.ro/trxer/<br/>

<b>Navigate Easily</b><br/>
Trxer so friendly UI will make your life easier,much easier.You can navigate through test classed,<br/>
see outputs,messages,stacktrace,test duration and much more.

<b>Read Clearly</b><br/>
TRXER html report is eye friendly which means you will understand all you need at one glimpse look.<br/>
No mess,no misunderstood fonts.

<b>Find Problem Faster</b><br/>
With our friendly UI, 
you can watch stacktraces,outputs and messages so you can determine what's the problem as quickly as lightning.<br/>

<b>Using Graphs</b><br/>
We draw graphs for you so you can see the status of each test class and the total passed,<br/>
failed and warnings of all tests which you can download and use later.

<b>Colors</b>
TRXER html report is colorful.<br/>
Each color:<br/>
<ul>
  <li>green</li>
  <li>red</li>
  <li>yellow</li>
</ul>
indicate test status and tells you whether test passed,failed or got warned during run.

<b>Images</b><br/>
assume you have an image to show in the report , just put it's url in the test message,stdout or stderror and<br/>
Trxer autimatically will show your image in the final html report<br/>
<br/>
What you should do is surround the url with Quotes like the folowing:<br/>
```bash
"image url here"
```

![trxdemo2](https://cloud.githubusercontent.com/assets/11910876/7187656/ccb4093a-e47a-11e4-8cb0-7d4ad975d52e.PNG)

<b>Stacktraces</b><br/>
Providing a clear view to understand stacktraces:<br/>
![trxdemo3](https://cloud.githubusercontent.com/assets/11910876/7187675/e637ec96-e47a-11e4-85f9-37c715540706.PNG)


<b>Supporting Versions</b><br/>
TRXER supports visual studio 2010 and higher (xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010")<br/>
but can easily supports lower versions by lowering the '2010' year to whatever you like.

<b>Supporting Browsers</b><br/>
Trxer supported by all major browsers that supports Html5 Canvas<br/>

<b>Usage</b><br/>
Trxer is an EXE file.<br/>
Trxer.exe <file.trx><br/>
The output will be at the trx folder under the name "file.trx.html"<br/>

```bash
TrxerConsole.exe <TRX file>
```

This is how it looks like

![alt tag](https://cloud.githubusercontent.com/assets/11910876/7106811/6332ee2a-e157-11e4-94cf-bf3683ca545d.PNG)
