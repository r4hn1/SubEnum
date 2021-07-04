# SubEnum

This script is used to gather the info about subdomains via bruteforce,then it will search for records and move to search for headers.

## Installation and Uses.

Very simple to use and install download a file called ```SubEnum.sh``` change the permission and run it or

```
# git clone https://github.com/r4hn1/SubEnum.git
# cd SubEnum
# chmod +x SubEnum.sh
# cp /opt/subenum/SubEnum.sh /usr/bin/subenum
# subenum
```

## Source Files

Tools Used:
```
https://github.com/blechschmidt/massdns
https://github.com/projectdiscovery/subfinder
https://github.com/projectdiscovery/dnsx
https://github.com/projectdiscovery/httpx
```

Reference Files:
```
https://github.com/blechschmidt/massdns/blob/master/lists/resolvers.txt
https://gist.github.com/jhaddix/86a06c5dc309d08580a018c66354a056
```

## Details 

After completing the script process it will create a directory with domain name in current directory.
And also create Five Files.

File Name | Uses |
----------|------|
example.com.txt	|				  Found Subdomain List |
example.com.record.txt	|	Records File |
example.com.merge.txt		|	Sorted and Unique complete data |
example.com.final.txt		|	Final filtered subdomain list |
example.com.http.txt		|	Http header list |


## Updates

Currently project is not yet finished, We are working on project to work more smoothly in less time.

## Help

If you found any problem with the script or any suggetion to improve the performance.
Kindly ping me on.<br>
Twitter : [r4hn1](https://twitter.com/r4hn1)<br>
LinkedIn : [r4hn1](https://www.linkedin.com/in/r4hn1/)

