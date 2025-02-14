---
layout: post
title: HTTP basic authentication - Apache
tags:
- FOSS
- Knowledge base
- Apache
- Authentication
- Htaccess
- Http basic
---

Method 1)
Inside the directory you wish to protect include a .htaccess file with the following content:

```text
AuthUserFile /some/secure/path/outside/the/public/docs/.htpasswd
AuthName "My secure area"
AuthType Basic
Require valid-user
```

Method 2)
In your apache config file add the following:

```text
<Directory /path/to/directory/to/protect/>
 AuthUserFile /some/secure/path/outside/the/public/docs/.htpasswd
 AuthName "My secure area"
 AuthType Basic
 Require valid-user
</Directory>
```

Now you have configured apache for authentication you need to create a password "databases". This is a file in a format apache can understand.

You can create it with the htpasswd command:

```text
htpasswd -c /some/secure/path/outside/the/public/docs/.htpasswd myusername
```

Once you have your password database, if you need to update a users password or add more users you can use the htpasswd command without the -c option, like so:

```text
htpasswd /some/secure/path/outside/the/public/docs/.htpasswd myusername
```
