---
comments: true
layout: post
title: HTTP basic authentication - Apache
tags:
- Apache
- Foss
- Knowledge base
- Apache
- Authentication
- Htaccess
- Http basic
---

Method 1)
Inside the directory you wish to protect include a .htaccess file with the following content:
{% highlight text %}
AuthUserFile /some/secure/path/outside/the/public/docs/.htpasswd
AuthName "My secure area"
AuthType Basic
Require valid-user
{% endhighlight %}

Method 2)
In your apache config file add the following:
{% highlight text %}
<Directory /path/to/directory/to/protect/>
 AuthUserFile /some/secure/path/outside/the/public/docs/.htpasswd
 AuthName "My secure area"
 AuthType Basic
 Require valid-user
</Directory>
{% endhighlight %}

Now you have configured apache for authentication you need to create a password "databases". This is a file in a format apache can understand.

You can create it with the htpasswd command:
{% highlight text %}
htpasswd -c /some/secure/path/outside/the/public/docs/.htpasswd myusername
{% endhighlight %}

Once you have your password database, if you need to update a users password or add more users you can use the htpasswd command without the -c option, like so:
{% highlight text %}
htpasswd /some/secure/path/outside/the/public/docs/.htpasswd myusername
{% endhighlight %}
