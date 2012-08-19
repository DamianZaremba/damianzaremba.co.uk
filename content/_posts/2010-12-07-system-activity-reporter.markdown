---
comments: true
layout: post
title: System activity reporter
tags:
- Foss
---

Ever wanted to be able to get historical performance data on your linux system without setting up an entire rrd based graphing system? Maybe you don't even want graphs you just want to know that if needed you can find out what your memory usage was last week.

A nice simple program is the system activity reporter or SAR.

To get started you'll want to install and start sysstat, on a centos box this can be done as below:

{% highlight bash %}
# Make sure the system is up to date
yum update

# Install the sysstat program (includes sar and iostat)
sudo yum install sysstat

# Make sure sysstat is enabled
chkconfig sysstat on

# Start sysstat – this starts the system activity data collector
service sysstat start
{% endhighlight %}

Ok once we have sysstat installed there are a few programs we can use to get performance data, iostat and sar (there are loads of other things such as mpstat, pidstat, nfsiostat, cifsiostat etc but for this post I'll only be covering the 2). I'll give you some basic examples of what we can do with these tools but they are very extensive so I suggest that you check out the man pages (man sar + man iostat)

**IOStat**

iostat is mainly for reporting CPU statistics and input/output statistics for devices/partitions. Some examples of this can be seen below:

{% highlight bash %}
[root@xxx ~]# iostat
Linux my.kernel.version (my.hostname) 12/07/10
avg-cpu: %user %nice %system %iowait %steal %idle
0.35 0.00 0.19 0.61 0.01 98.84
Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
xvda 11.04 174.56 96.57 1575022426 871286088
xvdb 0.92 14.90 10.14 134403952 91524480
xvdc 0.91 12.16 10.53 109676480 95014488
{% endhighlight %}

The above output is avg history since last boot, now if your debugging a current issue on the system this probably isin't helpful to you so lets get the current values at 2 second intervals instead:

{% highlight bash %}
[root@xxx ~]# iostat -d 2
Linux my.kernel.version (my.hostname) 12/07/10
avg-cpu: %user %nice %system %iowait %steal %idle
0.35 0.00 0.19 0.61 0.01 98.84
Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
xvda 11.04 174.56 96.57 1575022426 871286088
xvdb 0.92 14.90 10.14 134403952 91524480
xvdc 0.91 12.16 10.53 109676480 95014488

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
xvda 0.00 0.00 0.00 0 0
xvdb 0.00 0.00 0.00 0 0
xvdc 0.00 0.00 0.00 0 0

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
xvda 0.00 0.00 0.00 0 0
xvdb 0.00 0.00 0.00 0 0
xvdc 0.00 0.00 0.00 0 0
{% endhighlight %}

This output actually just carries on adding a new entry every 2 seconds, to limit the entries then just specify the number as below:

{% highlight bash %}
[root@xxx ~]# iostat -d 2 2
Linux my.kernel.version (my.hostname) 12/07/10
avg-cpu: %user %nice %system %iowait %steal %idle
0.35 0.00 0.19 0.61 0.01 98.84
Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
xvda 11.04 174.56 96.57 1575022426 871286088
xvdb 0.92 14.90 10.14 134403952 91524480
xvdc 0.91 12.16 10.53 109676480 95014488

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
xvda 0.00 0.00 0.00 0 0
xvdb 0.00 0.00 0.00 0 0
xvdc 0.00 0.00 0.00 0 0
{% endhighlight %}

As you can see this testing vm is actually currently doing nothing but if I run this on a production machine you can see why this information is helpful for spotting bottle necks etc:

{% highlight bash %}
root@xxx:~# iostat -d 2 2
Linux my.kernel.version (my.hostname) 12/07/10 _x86_64_

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
sda 31.14 411.84 757.85 1890371422 3478544478
sda1 31.01 409.90 755.62 1881435002 3468289496
sdb 9.97 88.27 303.57 405165646 1393372152
sdb1 9.97 88.27 303.57 405164878 1393372152
sdc 7.54 57.13 131.10 262215600 601759006
sdc1 7.54 57.13 131.10 262214832 601759006

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
sda 269.00 4.00 5968.00 8 11936
sda1 269.00 4.00 5968.00 8 11936
sdb 15.00 8.00 416.00 16 832
sdb1 15.00 8.00 416.00 16 832
sdc 71.00 12.00 752.00 24 1504
sdc1 71.00 12.00 752.00 24 1504
{% endhighlight %}

Yes I know I started talking about memory, cpu etc at the start of this post but you should care about your disks too! Anyway onto sar..

**System activity reporter (Sar)**
As the name suggests it's not for reporting io data, it is mainly for reporting system data. What do we mean by "system data"? Well this covers lots of things such as:



    
  * CPU

    
  * Load avg

    
  * Memory usage

    
  * Inode/file/kernel table usage

    
  * Swapping stats

    
  * Process statistics

    
  * TTY device activity

    
  * Much much more....


Some common things your probably want to look at;
CPU usage:

{% highlight bash %}
sar -u
{% endhighlight %}

Memory usage:

{% highlight bash %}
sar -r
{% endhighlight %}

Load avg (and queue length):

{% highlight bash %}
sar -q
{% endhighlight %}

Now without any other options sar is going to return you information from the current sar file, to get a different days content then specify the file.

Today is the 7th, say I wanted to see CPU data for yesterday I would run:

{% highlight bash %}
sar -s -f /var/log/sa/sa06
{% endhighlight %}

Now depending on what data you are requesting (please read the man page on what data you can retrive and how you can format it, I am refering to the defaults!) the output will vary, example output for CPU data is as follows:

{% highlight bash %}
[root@xxx~]# sar -s | head
Linux my.kernel.version (my.hostname) 12/07/10

08:00:01 CPU %user %nice %system %iowait %steal %idle
08:10:01 all 0.61 0.00 0.40 0.14 0.08 98.78
08:20:01 all 0.29 0.00 0.28 0.01 0.01 99.41
08:30:01 all 0.23 0.00 0.25 0.01 0.01 99.50
08:40:01 all 0.56 0.00 0.36 0.07 0.01 99.00
08:50:01 all 0.29 0.00 0.28 0.04 0.01 99.39
09:00:01 all 0.21 0.00 0.26 0.02 0.01 99.50
09:10:01 all 0.66 0.00 0.41 0.34 0.03 98.57
{% endhighlight %}

**But I want some graphs!**
Awesome, let's make some using gnuplot! We are going to use sadf, this is a program that lets us format/display sar data in different formats really easily.
You like excel? I'm sorry to hear that, here is an example of outputting cpu idle data in csv form anyway (just to keep you happy):

{% highlight bash %}
sadf -- -u | awk '/%idle/ {print $3","$6}'
{% endhighlight %}

Anyway for those geeks among us lets make some pretty stuff in gnuplot:

{% highlight bash %}
# Make a tmp file
cpu_data_file=$(mktemp /tmp/cpu_data.XXX);
# Fill the file with stuff
sadf -- -u | awk '/%idle/ {print $3" "$6}' > $cpu_data_file
# Make a pretty graph
echo "set terminal dump;
set title 'CPU usage';
set xdata time;
set timefmt '%s';
set xlabel 'Time';
plot '$cpu_data_file' using 1:2 with lines title 'CPU usage';" | gnuplot
# Remove tmp file
rm -f $cpu_data_file
{% endhighlight %}

If your not a ASCII type of guy then change set terminal dump; to set terminal png; and pipe the output to file for some nice images.

If your interested then I hacked up a quick example of making graphs for displaying on the web:

{% highlight bash %}
#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# sar_graph.sh - Makes pretty web pages from sar
# Written by Damian Zaremba - Released under GPLv3
#
# Please note this is a quick hack to demonstrate it can be done
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

GNU_PLOT=$(whereis gnuplot | cut -d' ' -f2)
SADF=$(whereis sadf | cut -d' ' -f2)
GRAPH_TYPE="image"
#GRAPH_TYPE="ascii"
HTML_DST="/var/www/vhosts/stuff.damianzaremba.co.uk/public/sar_graph/"
POST_COMMANDS='chown www-server:www-data -R '$HTML_DST

# Check gnuplot is all good
if [ ! -x "$GNU_PLOT" ];
then
 echo "Please ensure gnuplot is avaible on \$PATH"
 exit 1;
fi

# Check sadf is all good
if [ ! -x "$SADF" ]
then
 echo "Please ensure sadf is avaible on \$PATH"
 exit 1;
fi

# Check graph type
if [ "$GRAPH_TYPE" != "image" ] && [ "$GRAPH_TYPE" != "ascii" ]
then
 echo "Invalid graph type specified"
 exit 1;
fi

# Some functions for writing out the html, just incase you ever want to make it pretty or something..
function make_header {
 HTML="<html><head><title>Sar graphs!</title></head><body>"$HTML;
}

function make_footer {
 HTML=$HTML"</body></html>";
}

function make_graph {
 if [ -z "$1" ]; then return 1; else title=$1; fi
 if [ -z "$2" ]; then return 1; else format=$2; fi
 if [ -z "$3" ]; then return 1; else field=$3; fi

echo "Making $title"
 output_file=$(echo $title | sed 's/ /_/g')

if [ "$GRAPH_TYPE" == "image" ];
 then
 output_format="png"
 output_file=$output_file".png"
 else
 if [ "$GRAPH_TYPE" == "ascii" ]
 then
 output_format="dumb"
 output_file=$output_file".txt"
 fi
 fi

output_path=$HTML_DST"/"$output_file
 dat_file=$(mktemp /tmp/sar_graph.XXX)
 echo "Data file: $dat_file"
 $SADF -- $format | awk '/'$field'/ {print $3" "$6}' > $dat_file

echo "set terminal $output_format;
 set title '$title';
 set xdata time;
 set timefmt '%s';
 set xlabel 'Time';
 plot '$dat_file' using 1:2 with lines title '$title';" | $GNU_PLOT > $output_path
 echo "Outputted $output_file"

if [ "$GRAPH_TYPE" == "image" ];
 then
 HTML=$HTML'<img src="'$output_file'" alt="'$title'" />'
 else
 if [ "$GRAPH_TYPE" == "ascii" ]
 then
 HTML=$HTML'<iframe src="'$output_file'" width="650px" height="350px" scrolling="no"></iframe>'
 fi
 fi
}

# Main script stuff
test -d "$HTML_DST" || mkdir -p "$HTML_DST"
HTML=""

# CPU stuff
make_graph "CPU usage" "-u" "%idle"

# Swap stuff
make_graph "Swap usage" "-r" "kbbuffers"

# 1min load avg
make_graph "1min Load avg" "-q" "ldavg-1"

# Make the html index
echo "Writing $HTML_DST/index.html"
make_header; make_footer
echo $HTML > "$HTML_DST/index.html"

# Post stuff
`$POST_COMMANDS`

# Tidy
rm -rf "$base_dir"
{% endhighlight %}
