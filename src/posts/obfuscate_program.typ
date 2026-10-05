#import "../theme.typ": hr

The following program will replace characters in text files that may not display correctly
in HTML files. I wrote it to make including code snippets in my website easier. In vim, you
can read in the output of this command to the current line with the command
`r!obfuscate.exe <input>`.  The text file `<input>` will
be printed (escaped) under the cursor location.

*NOTE* Now that I have migrated the website to Typst, this program is no longer necessary.
Simple code blocks will highlight and display code nicely on the website. However, I leave
it here because it was a useful tool that I used before the website was modernized by AI.
You might call it a relic of the good old days...

#hr

*Program `obfuscate.cpp`*

```cpp
/* Escape characters in text files for HTML dislpay.
 * INTEL  icx obfuscate.cpp /Qstd:c++23 
 * GNU    g++ obfuscate.cpp -std=c++23  */
#include <fstream>
#include <iostream>
#include <print>
#include <regex>
#include <string>

int main(int argc, char **argv) {
    if (argc != 2) {
        std::print(std::cerr, "ERROR: Incorrect number of parameters.\n");
        std::print(std::cerr, "USAGE: {} <input_file>\n", argv[0]);
        return 1;
    }

    /* The first argument is a path to a text file that we will convert to html format. */
    std::ifstream in(argv[1], std::ios::binary);
    if (!in) {
        std::print(std::cerr, "ERROR: Failed to open file: {}\n", argv[1]);
        return 1;
    }

    /* Read the entire file into a string. */
    std::string s((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    if (in.bad()) {
        std::print(std::cerr, "ERROR: Opened {} but failed to read content.\n", argv[1]);
        return 1;
    }

    /* Format text such that it will display nicely in HTML. 
     * Note that order of operations below matters. If &amp; replacement
     * happend after, say, &lt; replacement, then the & in &lt; will be
     * replaced. Similar story for \r or <br>. Beware! */
    s = std::regex_replace(s, std::regex("&"), "&amp;");
    s = std::regex_replace(s, std::regex("<"), "&lt;");
    s = std::regex_replace(s, std::regex(">"), "&gt;");
    s = std::regex_replace(s, std::regex("\r"), "");       /* Just cause Windows... */
    s = std::regex_replace(s, std::regex("\n"), "<br>\n");
    s = std::regex_replace(s, std::regex("\t"), "&nbsp;&nbsp;&nbsp;&nbsp;");
    s = std::regex_replace(s, std::regex(" "), "&nbsp;");

    std::print("<code>\n{}</code>", s);
    return 0;
}
```

#hr

*Output of `obfuscate.exe obfuscate.cpp`*

```text
/*&nbsp;Escape&nbsp;characters&nbsp;in&nbsp;text&nbsp;files&nbsp;for&nbsp;HTML&nbsp;dislpay.<br>
&nbsp;*&nbsp;INTEL&nbsp;&nbsp;icx&nbsp;obfuscate.cpp&nbsp;/Qstd:c++23&nbsp;<br>
&nbsp;*&nbsp;GNU&nbsp;&nbsp;&nbsp;&nbsp;g++&nbsp;obfuscate.cpp&nbsp;-std=c++23&nbsp;&nbsp;*/<br>
#include&nbsp;&lt;fstream&gt;<br>
#include&nbsp;&lt;iostream&gt;<br>
#include&nbsp;&lt;print&gt;<br>
#include&nbsp;&lt;regex&gt;<br>
#include&nbsp;&lt;string&gt;<br>
<br>
int&nbsp;main(int&nbsp;argc,&nbsp;char&nbsp;**argv)&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(argc&nbsp;!=&nbsp;2)&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;std::print(std::cerr,&nbsp;"ERROR:&nbsp;Incorrect&nbsp;number&nbsp;of&nbsp;parameters.\n");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;std::print(std::cerr,&nbsp;"USAGE:&nbsp;{}&nbsp;&lt;input_file&gt;\n",&nbsp;argv[0]);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;1;<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;The&nbsp;first&nbsp;argument&nbsp;is&nbsp;a&nbsp;path&nbsp;to&nbsp;a&nbsp;text&nbsp;file&nbsp;that&nbsp;we&nbsp;will&nbsp;convert&nbsp;to&nbsp;html&nbsp;format.&nbsp;*/<br>
&nbsp;&nbsp;&nbsp;&nbsp;std::ifstream&nbsp;in(argv[1],&nbsp;std::ios::binary);<br>
&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!in)&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;std::print(std::cerr,&nbsp;"ERROR:&nbsp;Failed&nbsp;to&nbsp;open&nbsp;file:&nbsp;{}\n",&nbsp;argv[1]);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;1;<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;Read&nbsp;the&nbsp;entire&nbsp;file&nbsp;into&nbsp;a&nbsp;string.&nbsp;*/<br>
&nbsp;&nbsp;&nbsp;&nbsp;std::string&nbsp;s((std::istreambuf_iterator&lt;char&gt;(in)),&nbsp;std::istreambuf_iterator&lt;char&gt;());<br>
&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(in.bad())&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;std::print(std::cerr,&nbsp;"ERROR:&nbsp;Opened&nbsp;{}&nbsp;but&nbsp;failed&nbsp;to&nbsp;read&nbsp;content.\n",&nbsp;argv[1]);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;1;<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;Format&nbsp;text&nbsp;such&nbsp;that&nbsp;it&nbsp;will&nbsp;display&nbsp;nicely&nbsp;in&nbsp;HTML.&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;Note&nbsp;that&nbsp;order&nbsp;of&nbsp;operations&nbsp;below&nbsp;matters.&nbsp;If&nbsp;&amp;amp;&nbsp;replacement<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;happend&nbsp;after,&nbsp;say,&nbsp;&amp;lt;&nbsp;replacement,&nbsp;then&nbsp;the&nbsp;&amp;&nbsp;in&nbsp;&amp;lt;&nbsp;will&nbsp;be<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;replaced.&nbsp;Similar&nbsp;story&nbsp;for&nbsp;\r&nbsp;or&nbsp;&lt;br&gt;.&nbsp;Beware!&nbsp;*/<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("&amp;"),&nbsp;"&amp;amp;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("&lt;"),&nbsp;"&amp;lt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("&gt;"),&nbsp;"&amp;gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("\r"),&nbsp;"");&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;Just&nbsp;cause&nbsp;Windows...&nbsp;*/<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("\n"),&nbsp;"&lt;br&gt;\n");<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("\t"),&nbsp;"&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;s&nbsp;=&nbsp;std::regex_replace(s,&nbsp;std::regex("&nbsp;"),&nbsp;"&amp;nbsp;");<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;std::print("&lt;code&gt;\n{}&lt;/code&gt;",&nbsp;s);<br>
&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;0;<br>
}<br>
```
